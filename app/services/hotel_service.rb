class HotelService
  include HTTParty
  base_uri "https://app.rakuten.co.jp/services/api/Travel/KeywordHotelSearch/20170426"

  def initialize(api_key)
    @api_key = api_key # APIキーを初期化
  end

  def search_all_inclusive_hotels(keyword, page: 1, hits: 30)
    options = {
      query: {
        "applicationId" => @api_key,
        "keyword" => "#{keyword} オールインクルーシブ",
        "format" => "json",
        "responseType" => "middle",
        "page" => page
      }
    }

    response = self.class.get("", options)
    return nil unless response.success?

    parsed_response = response.parsed_response
    hotels = parsed_response["hotels"]
    return nil if hotels.nil? || hotels.empty?

    hotels
  end

  def get_hotel_details(hotel_no, fields: [])
    detail_base_uri = "https://app.rakuten.co.jp/services/api/Travel/HotelDetailSearch/20170426"
    options = {
      query: {
        "applicationId" => @api_key,
        "hotelNo" => hotel_no,
        "format" => "json",
        "elements" => fields.join(",")
      }
    }

    response = self.class.get(detail_base_uri, options)
    return nil unless response.success? # レスポンスが成功でない場合はnilを返す

    parsed_response = response.parsed_response
    parsed_response.dig("hotels", 0, "hotel", 0, "hotelBasicInfo") # ホテル基本情報を返す
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
    latitude = hotel_info["latitude"].to_f
    longitude = hotel_info["longitude"].to_f

    begin
      Hotel.create!(
        id: hotel_info["hotelNo"],
        name: hotel_info["hotelName"],
        hotel_information_url: hotel_info["hotelInformationUrl"],
        hotel_image_url: hotel_info["hotelImageUrl"],
        hotel_special: hotel_info["hotelSpecial"],
        latitude: latitude,
        longitude: longitude,
        all_inclusive: true
      )
    rescue ActiveRecord::RecordNotUnique
      Rails.logger.info "Hotel already exists: #{hotel_info['hotelNo']}"
    end
  end
end
