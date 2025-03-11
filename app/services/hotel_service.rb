class HotelService
  include HTTParty
  base_uri 'https://app.rakuten.co.jp/services/api/Travel/KeywordHotelSearch/20170426'

  def initialize(api_key)
    @api_key = api_key
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

    if response.success?
      parsed_response = response.parsed_response
      parsed_response['hotels'] || []
    else
      Rails.logger.error("API Request Failed: #{response.code} - #{response.message}")
      []
    end
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

    if response.success?
      parsed_response = response.parsed_response
      if parsed_response['hotels'] && parsed_response['hotels'][0] && parsed_response['hotels'][0]['hotel']
        parsed_response['hotels'][0]['hotel'][0]['hotelBasicInfo']
      else
        Rails.logger.warn("Hotel details not found for hotelNo: #{hotel_no}")
        nil
      end
    else
      Rails.logger.error("Hotel details request failed: #{response.code} - #{response.message}")
      nil
    end
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
