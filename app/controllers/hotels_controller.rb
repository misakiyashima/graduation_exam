class HotelsController < ApplicationController
  def index
    @hotels = Hotel.where(all_inclusive: true)
  end

  def show
    client = HotelService.new ('1092610730557101212')
    @hotel = client.get_hotel_details (params[:id])
    if @hotel.nil?
      flash[:alert] = "ホテルの詳細情報が見つかりません。"
      redirect_to hotels_path
    else
      @hotel_information_url = @hotel['hotelInformationUrl']
    end
  end

  def search
    client = HotelService.new ('1092610730557101212')
    response = client.search_all_inclusive_hotels(params[:keyword])
    @hotels = response.map { |hotel| hotel['hotel'][0]['hotelBasicInfo'] } unless response.nil?
    if @hotels.nil? || @hotels.empty?
      flash[:alert] = "検索結果がありません。"
      @hotels = []
    end
    render :index
  end

  def bookmarks
    @bookmark_hotels = current_user.bookmark_hotels.includes(:user).order(created_at: :desc)
  end
end
