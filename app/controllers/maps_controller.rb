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
    hotel_service = HotelService.new(ENV["RAKUTEN_API_KEY"])

    # APIからホテル情報を取得
    hotel_info = hotel_service.get_hotel_details(hotel_no, fields: [ "hotelName", "hotelSpecial", "hotelImageUrl", "hotelInformationUrl" ])

    # ホテル情報が見つからない場合の処理
    if hotel_info.nil?
      Rails.logger.error "Hotel details not found for ID: #{hotel_no}"
      flash[:alert] = "ホテル情報が見つかりません。"
      redirect_to maps_path and return
    end

    # ホテルタグを取得して追加
    tags = HotelTag.where(hotel_id: hotel_no).includes(:tag).map { |hotel_tag| hotel_tag.tag.name }
    hotel_info["tags"] = tags

    @hotel = hotel_info
    @hotel["hotelNo"] ||= hotel_no # 必要に応じてhotelNoを補完

    # タグ作成フォーム用のインスタンス変数
    @hotel_tag = HotelTag.new
    @hotel_id = hotel_no
  end
end
