class MapsController < ApplicationController
  def index
    @google_maps_api_key = ENV["GOOGLE_MAPS_API_KEY"]

    keyword = "オールインクルーシブ"
    hotel_service = HotelService.new(ENV["RAKUTEN_API_KEY"])
    all_hotels = hotel_service.fetch_all_hotels(keyword)

    if all_hotels.present?
       # ① まず hotelNo を全部抜き出す
       hotel_nos = all_hotels.map { |h| h["hotel"][0]["hotelBasicInfo"]["hotelNo"] }

      # ② DB の Hotel レコードを一括取得（SQL 1回）
      hotel_records = Hotel
        .where(external_id: hotel_nos)
        .includes(hotel_tags: :tag)
        .index_by(&:external_id)

      # ③ map の中では DB を叩かない
      @hotels = all_hotels.map do |hotel|
        info = hotel["hotel"][0]["hotelBasicInfo"]
        coordinates = CoordinateConverter.to_wgs84(info["latitude"], info["longitude"])

        { 
          hotelNo: info["hotelNo"],
          name: info["hotelName"],
          latitude: coordinates[:latitude],
          longitude: coordinates[:longitude],
          hotel_record: hotel_records[info["hotelNo"]],
          info_content: "<h3>#{info['hotelName']}</h3><p>#{info['hotelSpecial']}</p>"
        }
      end
    else
      Rails.logger.error "No hotels fetched from API"
      @hotels = []
    end
  end

  def details
    hotel_no = params[:id]
    client = HotelService.new(ENV["RAKUTEN_API_KEY"])

    # API から1件取得（DB保存はしない）
    response = client.get_hotel_details(hotel_no)
    if response.nil?
      flash[:alert] = "ホテル情報が見つかりません。"
      redirect_to maps_path and return
    end

    info = response["hotel"][0]["hotelBasicInfo"]

    # DB にホテルが存在する場合のみタグ表示に使う
    @hotel_record = Hotel.includes(hotel_tags: :tag).find_by(external_id: hotel_no)

    # view 用
    @hotel = info
  end
end
