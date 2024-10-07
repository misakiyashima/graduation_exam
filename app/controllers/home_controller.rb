class HomeController < ApplicationController
  def index
    @hotels = []
  end

  def search
    client = HotelService.new (ENV['1092610730557101212'])
    @hotels = client.search_all_inclusive_hotels (params[:keyword])
    if @hotels.empty?
      flash[:alert] = "検索結果がありません。"
    end
    render :index
  end

  def footer
    # フッターの内容を表示するためのアクション
     render partial: 'home/footer/footer'
  end
end
