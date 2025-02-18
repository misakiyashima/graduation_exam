class HotelsController < ApplicationController
  def index
    @hotels = Hotel.where(all_inclusive: true)
  end

  def show
    client = HotelService.new('1092610730557101212')
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
    client = HotelService.new('1092610730557101212')
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
