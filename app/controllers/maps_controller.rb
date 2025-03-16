class MapsController < ApplicationController
  def index
    @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']
    hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])

    Rails.logger.info "MapsController is being called"
    api_hotels = hotel_service.search_all_inclusive_hotels('オールインクルーシブ')
    Rails.logger.info "Number of hotels fetched: #{api_hotels.size}"

    if api_hotels.present?
      @hotels = api_hotels.map do |hotel|
        hotel_info = hotel['hotel'][0]['hotelBasicInfo']
        coordinates = CoordinateConverter.to_wgs84(hotel_info['latitude'], hotel_info['longitude'])

        {
          name: hotel_info['hotelName'],
          latitude: coordinates[:latitude],
          longitude: coordinates[:longitude],
          info_content: "<h3>#{hotel_info['hotelName']}</h3><p>#{hotel_info['hotelSpecial']}</p>"
        }
      end
    else
      Rails.logger.error "No hotels fetched from API in MapsController"
      @hotels = []
    end
    Rails.logger.info "Hotels Data size in MapsController: #{@hotels.size}"
  end
end
