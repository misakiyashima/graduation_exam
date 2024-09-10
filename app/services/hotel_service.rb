class HotelService
  BASE_URL = 'https://app.rakuten.co.jp/services/api/Travel/HotelDetailSearch/20170426'

  def self.search_hotels(keyword)
    response = HTTParty.get("#{}/search", query: { keyword: keyword, plan: 'オールインクルーシブ', api_key: '取得したAPIキー' })
    response.parsed_response
  end
end