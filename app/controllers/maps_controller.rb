class MapsController < ApplicationController
  def index
    @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']
    hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])

    # APIから宿泊施設を取得
    @hotels = hotel_service.search_all_inclusive_hotels('オールインクルーシブ').map do |hotel|
      hotel_info = hotel['hotel'][0]['hotelBasicInfo']
      {
        id: hotel_info['hotelNo'],
        name: hotel_info['hotelName'],
        latitude: hotel_info['latitude'],
        longitude: hotel_info['longitude'],
        hotel_information_url: hotel_info['hotelInformationUrl'],
        hotel_image_url: hotel_info['hotelImageUrl'],
        hotel_special: hotel_info['hotelSpecial']
      }
    end
  end
end
