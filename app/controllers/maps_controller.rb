class MapsController < ApplicationController
  def index
    @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']
    hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])

    # オールインクルーシブの宿泊施設を取得
    api_hotels = hotel_service.search_all_inclusive_hotels('オールインクルーシブ')

    # 緯度・経度をWGS84に変換し、マーカー情報を準備
    @hotels = api_hotels.map do |hotel|
      hotel_info = hotel['hotel'][0]['hotelBasicInfo']
      coordinates = CoordinateConverter.to_wgs84(hotel_info['latitude'].to_f, hotel_info['longitude'].to_f)
      {
        name: hotel_info['hotelName'],
        latitude: coordinates[:latitude],
        longitude: coordinates[:longitude],
        info_content: "<h3>#{hotel_info['hotelName']}</h3><p>#{hotel_info['hotelSpecial']}</p>"
      }
    end
  end
end
