class MapsController < ApplicationController
  layout false
  def index
    @google_maps_api_key = ENV["GOOGLE_MAPS_API_KEY"]

    keyword = "オールインクルーシブ"
    Rails.logger.info "Fetching all hotels with keyword: '#{keyword}'"

    hotel_service = HotelService.new(ENV["RAKUTEN_API_KEY"])
    all_hotels = hotel_service.fetch_all_hotels(keyword)

    if all_hotels.present?
      @hotels = all_hotels.map do |hotel|
        hotel_info = hotel["hotel"][0]["hotelBasicInfo"]
        coordinates = CoordinateConverter.to_wgs84(hotel_info["latitude"], hotel_info["longitude"])

        {
          hotelNo: hotel_info["hotelNo"],
          name: hotel_info["hotelName"],
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
