class MapsController < ApplicationController
  def index
    @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']
    hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])
    @hotels = hotel_service.search_all_inclusive_hotels('オールインクルーシブ')
  end
end
