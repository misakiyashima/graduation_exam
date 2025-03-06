class MapsController < ApplicationController
  def index
    @google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']
    hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])

    # APIから「オールインクルーシブ」の宿を取得
    api_hotels = hotel_service.search_all_inclusive_hotels('オールインクルーシブ')

    # データベースに保存 & キャッシュとして活用
    @hotels = api_hotels.map do |hotel|
      hotel_info = hotel['hotel'][0]['hotelBasicInfo']
      
      # save_hotel_to_dbを呼び出して保存
      hotel_service.save_hotel_to_db(hotel_info)
      
      hotel_info
    end
  end
end
