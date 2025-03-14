class MapsController < ApplicationController
  def index
    @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']
    hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])

    # オールインクルーシブの宿泊施設を取得
    api_hotels = hotel_service.search_all_inclusive_hotels('オールインクルーシブ')
    Rails.logger.info "Fetched Hotels from API in MapsController: #{api_hotels.inspect}"

    # データが存在するかチェック
    if api_hotels.present?
      @hotels = api_hotels.map do |hotel|
        hotel_info = hotel['hotel'][0]['hotelBasicInfo']
        Rails.logger.info "Hotel Info in MapsController: #{hotel_info.inspect}"
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
    Rails.logger.info "Hotels Data in MapsController: #{@hotels.inspect}"
  end
end
