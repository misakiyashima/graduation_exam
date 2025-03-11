def index
  @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']
  hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])

  # オールインクルーシブ宿泊施設データを取得
  api_hotels = hotel_service.search_all_inclusive_hotels('オールインクルーシブ')

  # 緯度・経度を変換してデータをセット
  @hotels = api_hotels.map do |hotel|
    hotel_info = hotel['hotel'][0]['hotelBasicInfo']
    coordinates = CoordinateConverter.to_wgs84(hotel_info['latitude'].to_f, hotel_info['longitude'].to_f)
    {
      id: hotel_info['hotelNo'],
      name: hotel_info['hotelName'],
      latitude: coordinates[:latitude],
      longitude: coordinates[:longitude],
      hotel_information_url: hotel_info['hotelInformationUrl'],
      hotel_image_url: hotel_info['hotelImageUrl'],
      hotel_special: hotel_info['hotelSpecial']
    }
  end
end
