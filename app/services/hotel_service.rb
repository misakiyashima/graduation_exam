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
        'keyword' => keyword,
        'format' => 'json',
        'responseType' => 'middle'
      }
    }
    response = self.class.get('', options)
    Rails.logger.info("Request URL: #{self.class.base_uri}")
    Rails.logger.info("Request Options: #{options}")
    Rails.logger.info("Status Code: #{response.code}")
    Rails.logger.info("Response Body: #{response.body}")
    response.parsed_response['hotels']
  end
end