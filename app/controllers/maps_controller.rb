require_relative '../services/coordinate_converter'

class MapsController < ApplicationController
  def index
    begin
    require_relative '../services/coordinate_converter'
    Rails.logger.info "CoordinateConverter loaded successfully"
  rescue LoadError => e
    Rails.logger.error "Failed to load CoordinateConverter: #{e.message}"
  end

    @google_maps_api_key = "AIzaSyB40dUJlpgK6K_yevnhaRQYhasaR-FYW0E"
    hotel_service = HotelService.new("1092610730557101212")

    Rails.logger.info "MapsController is being called"
    api_hotels = hotel_service.search_all_inclusive_hotels('オールインクルーシブ')

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
