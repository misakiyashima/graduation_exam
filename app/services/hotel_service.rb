class HotelService
  include HTTParty
  base_uri 'https://app.rakuten.co.jp/services/api/Travel/HotelSearch/20170426'

  def initialize(api_key)
    @api_key = api_key
  end

  def search_all_inclusive_hotels(keyword)
    options = { query: { applicationId: @api_key, keyword: keyword, all_inclusive: true } }
    response = self.class.get('', options)
    filter_all_inclusive_hotels(response)
  end

  private

  def filter_all_inclusive_hotels(response)
    response['hotels'].select do |hotel|
      hotel['hotelBasicInfo']['hotelSpecial'].include?('オールインクルーシブ') ||
      hotel['hotelBasicInfo']['hotelSpecial'].include?('all-inclusive')
    end
  end
end