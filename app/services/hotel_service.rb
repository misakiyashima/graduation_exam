class HotelService
  include HTTParty
  base_uri "https://openapi.rakuten.co.jp/engine/api/Travel"

  def initialize(api_key)
    @api_key = api_key
  end

  def search_all_inclusive_hotels(keyword, page: 1, hits: 30)
    response = self.class.get(
      "/KeywordHotelSearch/20170426",
      {
        headers: { "Referer" => "https://www.all-inclusive.jp", "Origin"  => "https://www.all-inclusive.jp"},
        query: {
          "accessKey" => ENV["RAKUTEN_ACCESS_KEY"],
          "applicationId" => @api_key,
          "largeClassCode" => "japan",
          "keyword" => "オールインクルーシブ #{keyword}",
          "format" => "json",
          "responseType" => "middle",
          "page" => page
        }
      }
    )
    return nil unless response.success?

    parsed_response = response.parsed_response
    hotels = parsed_response["hotels"]
    return nil if hotels.nil? || hotels.empty?

    hotels
  end

  def get_hotel_details(hotel_no, fields: [])
    detail_base_uri = "https://openapi.rakuten.co.jp/engine/api/Travel/HotelDetailSearch/20170426"
    response = self.class.get(
      detail_base_uri,
      {
        headers: { "Referer" => "https://www.all-inclusive.jp", "Origin"  => "https://www.all-inclusive.jp" }, 
        query: {
          "accessKey" => ENV["RAKUTEN_ACCESS_KEY"],
          "applicationId" => @api_key,
          "hotelNo" => hotel_no,
          "format" => "json",
          "elements" => fields.join(",")
        }
      }
    )

    return nil unless response.success?

    parsed_response = response.parsed_response
    parsed_response.dig("hotels", 0, "hotel", 0, "hotelBasicInfo")
  end

  def fetch_all_hotels(keyword)
    all_hotels = []
    current_page = 1

    loop do
      hotels = search_all_inclusive_hotels(keyword, page: current_page, hits: 100)
      break if hotels.nil? || hotels.empty?

      all_hotels.concat(hotels)
      current_page += 1
    end

    all_hotels
  end

  # ホテルデータをデータベースに保存
  def save_hotel_to_db(hotel_info)
    external_id = hotel_info["hotelNo"]
    detail = get_hotel_details(external_id)

    Hotel.find_or_create_by!(external_id: external_id) do |hotel|
      hotel.name = hotel_info["hotelName"]
      hotel.hotel_image_url = hotel_info["hotelImageUrl"]
      hotel.hotel_special = hotel_info["hotelSpecial"]
      hotel.latitude = hotel_info["latitude"].to_f
      hotel.longitude = hotel_info["longitude"].to_f
      hotel.all_inclusive = true
      hotel.hotel_information_url = detail["hotelInformationUrl"]
    end
  rescue ActiveRecord::RecordNotUnique
    Rails.logger.info "Hotel already exists: #{hotel_info['hotelNo']}"
  end
end
