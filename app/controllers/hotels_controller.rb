class HotelsController < ApplicationController
  def index
    client = HotelService.new(ENV['RAKUTEN_API_KEY'])
    response = client.search_all_inclusive_hotels('オールインクルーシブ')

    @hotels = response.map do |hotel|
      hotel_info = hotel['hotel'][0]['hotelBasicInfo']
      hotel_info.merge('tags' => [], 'hotelNo' => hotel_info['hotelNo'])
    end

    # 検索結果がない場合の対応
    if @hotels.blank?
      flash[:alert] = "「オールインクルーシブ」で該当する宿泊施設はありません。"
      @hotels = []
    end
    # Kaminari のページネーションを追加（1ページあたり10件表示）
    @hotels = Kaminari.paginate_array(@hotels).page(params[:page]).per(10)
  end

  def show
    client = HotelService.new(ENV['RAKUTEN_API_KEY'])
    hotel_info = client.get_hotel_details(params[:id], fields: ['hotelName', 'hotelImageUrl', 'hotelInformationUrl', 'hotelSpecial'])
    if hotel_info.nil?
      flash[:alert] = "ホテルの詳細情報が見つかりません。"
      redirect_to hotels_path
    else
      @hotel_id = params[:id]
      @hotel = hotel_info
      @hotel_information_url = @hotel['hotelInformationUrl']
      @comments = Comment.where(hotel_id: params[:id])
      @comment = Comment.new
    end
  end

  def search
    client = HotelService.new(ENV['RAKUTEN_API_KEY'])
    response = client.search_all_inclusive_hotels(params[:keyword])
    @hotels = response.map do |hotel|
      hotel_info = hotel['hotel'][0]['hotelBasicInfo']
      tags = HotelTag.where(hotel_id: hotel_info['hotelNo']).includes(:tag).map { |ht| ht.tag.name }
      hotel_info.merge('tags' => tags)
    end if response.present?

    if @hotels.blank?
      flash[:alert] = "検索結果がありません。"
      @hotels = []
    end
    # Kaminari のページネーションを追加（1ページあたり10件表示）
    @hotels = Kaminari.paginate_array(@hotels).page(params[:page]).per(10)
    render :index
  end

  def bookmarks
    if current_user
      @bookmark_hotels = current_user.bookmarks.order(created_at: :desc)
    else
      @bookmark_hotels = []
    end
  end
end
