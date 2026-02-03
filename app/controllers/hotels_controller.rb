class HotelsController < ApplicationController
  def index
    client = HotelService.new(ENV["RAKUTEN_API_KEY"])
    response = client.search_all_inclusive_hotels("オールインクルーシブ")

    if response.present?
      hotel_ids = extract_hotel_ids(response)

      # preload + ハッシュ化（external_id → Hotel）
      @hotel_records = Hotel
        .where(external_id: hotel_ids)
        .includes(hotel_tags: :tag)
        .index_by(&:external_id)

      @hotels = build_hotels(response)
    else
      flash[:alert] = "「オールインクルーシブ」で該当する宿泊施設はありません。"
      @hotels = []
    end

    @hotels = Kaminari.paginate_array(@hotels).page(params[:page]).per(10)
  end

  def show
    client = HotelService.new(ENV["RAKUTEN_API_KEY"])

    # ① API からホテル情報を取得（表示用）
    @hotel = client.get_hotel_details(
      params[:id],
      fields: ["hotelName", "hotelImageUrl", "hotelInformationUrl", "hotelSpecial"]
    )
    if @hotel.nil?
      flash[:alert] = "ホテルの詳細情報が見つかりません。"
      redirect_to hotels_path and return
    end

    # ② DB のホテルを取得（なければ保存）
    @hotel_record = Hotel.find_by(external_id: params[:id])
    unless @hotel_record
      @hotel_record = client.save_hotel_to_db(@hotel)
    end
    # ③ コメントは DB の hotel_record に紐づく
    @comments = @hotel_record.comments.includes(:user)
    # ④ コメントフォーム用
    @comment = Comment.new
    # ⑤ コメントフォームが使う hotel_id（内部ID） 
    @hotel_id = @hotel_record.id
  end

  def search
    session[:last_search_url] = request.fullpath
    client = HotelService.new(ENV["RAKUTEN_API_KEY"])
    response = client.search_all_inclusive_hotels(params[:keyword])

    if response.present?
      hotel_ids = extract_hotel_ids(response)

      # preload + ハッシュ化
      @hotel_records = Hotel
        .where(external_id: hotel_ids)
        .includes(hotel_tags: :tag)
        .index_by(&:external_id)

      @hotels = build_hotels(response)
    else
      flash[:alert] = "検索結果がありません。"
      @hotels = []
    end

    @hotels = Kaminari.paginate_array(@hotels).page(params[:page]).per(10)
    render :index
  end

  def bookmarks
    @bookmark_hotels =
      if current_user
        current_user.bookmarks.order(created_at: :desc)
      else
        []
      end
  end

  private

  #  外部ID一覧を抽出
  def extract_hotel_ids(response)
    response.map { |h| h["hotel"][0]["hotelBasicInfo"]["hotelNo"] }
  end

  #  APIレスポンスをビュー用の構造に整形
  def build_hotels(response)
    response.map do |hotel|
      info = hotel["hotel"][0]["hotelBasicInfo"]
      info.merge("id" => info["hotelNo"])
    end
  end
end
