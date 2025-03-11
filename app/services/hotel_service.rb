class HotelService
  include HTTParty
  base_uri 'https://app.rakuten.co.jp/services/api/Travel/KeywordHotelSearch/20170426'

  def initialize(api_key)
    @api_key = api_key # 引数として渡された API キーを使用
  end

  def search_all_inclusive_hotels(keyword)
    options = {
      query: {
        'applicationId' => @api_key,
        'keyword' => "#{keyword} オールインクルーシブ",
        'format' => 'json',
        'responseType' => 'middle'
      }
    }
    response = self.class.get('', options)
    parsed_response = response.parsed_response
    parsed_response['hotels']
  end

  def get_hotel_details(hotel_no, fields: [])
    detail_base_uri = 'https://app.rakuten.co.jp/services/api/Travel/HotelDetailSearch/20170426'
    options = {
      query: {
        'applicationId' => @api_key,
        'hotelNo' => hotel_no,
        'format' => 'json',
        'elements' => fields.join(',')
      }
    }
    response = self.class.get(detail_base_uri, options)
    # デバッグ用のログを追加
    Rails.logger.info "API Response: #{response.body}"
    parsed_response = response.parsed_response
    hotel_info = parsed_response.dig('hotels', 0, 'hotel', 0, 'hotelBasicInfo')
    hotel_info ? hotel_info : nil
  end
  
  def save_hotel_to_db(hotel_info)
    latitude = hotel_info['latitude'].to_f
    longitude = hotel_info['longitude'].to_f

    Hotel.create!(
      id: hotel_info['hotelNo'],
      name: hotel_info['hotelName'],
      hotel_information_url: hotel_info['hotelInformationUrl'],
      hotel_image_url: hotel_info['hotelImageUrl'],
      hotel_special: hotel_info['hotelSpecial'],
      latitude: latitude,
      longitude: longitude,
      all_inclusive: true
    )
  rescue ActiveRecord::RecordNotUnique
    Rails.logger.info("Hotel already exists: #{hotel_info['hotelNo']}")
  end
end
