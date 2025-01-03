class HotelService
  include HTTParty
  base_uri 'https://app.rakuten.co.jp/services/api/Travel/KeywordHotelSearch/20170426'

  def initialize(api_key)
    @api_key = ENV['RAKUTEN_API_KEY']  #環境変数から API キーを取得
  end

  def search_all_inclusive_hotels(keyword)
    options = {
      query: {
        'applicationId' => @api_key,
        'keyword' => keyword,
        'format' => 'json',
        'responseType' => 'middle'
      }
    }
    response = self.class.get('', options)
    # デバッグログを追加
    Rails.logger.info("Request URL: #{self.class.base_uri}")
    Rails.logger.info("Request Options: #{options}")
    Rails.logger.info("Status Code: #{response.code}")
    Rails.logger.info("Response Body: #{response.body}")
    parsed_response = response.parsed_response
    Rails.logger.info("Parsed Response: #{parsed_response}")
    parsed_response['hotels']
  end

  def get_hotel_details(hotel_no)
    options = {
      query: {
        'applicationId' => @api_key,
        'hotelNo' => hotel_no,
        'format' => 'json'
      }
    }
    response = self.class.get('', options)
    # デバッグログを追加
    Rails.logger.info("Request URL: #{self.class.base_uri}")
    Rails.logger.info("Request Options: #{options}")
    Rails.logger.info("Status Code: #{response.code}")
    Rails.logger.info("Response Body: #{response.body}")
    parsed_response = response.parsed_response
    Rails.logger.info("Parsed Response: #{parsed_response}")
    if parsed_response['hotels'] && parsed_response['hotels'][0] && parsed_response['hotels'][0]['hotel']
      parsed_response['hotels'][0]['hotel'][0]['hotelBasicInfo']
    else
      nil
    end
  end
end

