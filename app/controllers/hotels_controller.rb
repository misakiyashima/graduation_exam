class HotelsController < ApplicationController
  def index
    @hotels = Hotel.where(all_inclusive: true)
  end

  def show
    @hotel = Hotel.find(params[:id])
  end

  def search
    client = HotelService.new('1092610730557101212')
    response = client.search_all_inclusive_hotels(params[:keyword])
    @hotels = response.map { |hotel| hotel['hotel'][0]['hotelBasicInfo'] } unless response.nil?
    if @hotels.nil? || @hotels.empty?
      flash[:alert] = "検索結果がありません。"
      @hotels = []
    end
    render :index
  end
end