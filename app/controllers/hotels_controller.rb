class HotelsController < ApplicationController
  def index
    @hotels = Hotel.where(all_inclusive: true)
  end

  def show
    @hotel = Hotel.find(params[:id])
  end

  def search
    client = HotelService.new(ENV['RAKUTEN_API_KEY'])
    @hotels = client.search_all_inclusive_hotels(params[:keyword])
  end
end