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

  # ① params[:id] が内部IDか外部IDか判定
  if Hotel.exists?(id: params[:id])
    # 内部IDでアクセスされた場合
    @hotel_record = Hotel.find(params[:id])
    external_id = @hotel_record.external_id

    # API を叩く必要はない（DB の情報で十分）
    @hotel = {
      "hotelName" => @hotel_record.name,
      "hotelImageUrl" => @hotel_record.hotel_image_url,
      "hotelSpecial" => @hotel_record.hotel_special,
      "hotelInformationUrl" => @hotel_record.hotel_information_url,
      "latitude" => @hotel_record.latitude,
      "longitude" => @hotel_record.longitude
    }

  else
    # 外部IDでアクセスされた場合
    external_id = params[:id]
    @hotel_record = Hotel.find_by(external_id: external_id)

    # 内部IDが存在するなら内部IDへ正規化
    if @hotel_record
      redirect_to hotel_path(@hotel_record.id) and return
    end

    # 内部IDがない → API から取得
    @hotel = client.get_hotel_details(
      external_id,
      fields: [
        "hotelName",
        "hotelImageUrl",
        "hotelInformationUrl",
        "hotelSpecial",
        "latitude",
        "longitude",
        "hotelNo"
      ]
    )

    if @hotel.nil?
      flash[:alert] = "ホテルの詳細情報が見つかりません。"
      redirect_to hotels_path and return
    end

    # DB に保存して内部IDへリダイレクト
    @hotel_record = client.save_hotel_to_db(@hotel)
    redirect_to hotel_path(@hotel_record.id) and return
  end

  # コメント表示
  @comments = @hotel_record.comments.includes(:user)
  @comment = Comment.new
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
