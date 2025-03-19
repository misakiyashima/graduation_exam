class MapsController < ApplicationController
  def index
    @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']

    keyword = 'オールインクルーシブ'
    Rails.logger.info "Fetching all hotels with keyword: '#{keyword}'"

    hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])
    all_hotels = hotel_service.fetch_all_hotels(keyword)

    if all_hotels.present?
      @hotels = all_hotels.map do |hotel|
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
      Rails.logger.error "No hotels fetched from API"
      @hotels = []
    end
  end
end
