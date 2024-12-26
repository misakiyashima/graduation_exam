class BookmarksController < ApplicationController
  def create
    hotel_no = params[:hotel_id]
    hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])
    hotel_details = hotel_service.get_hotel_details(hotel_no)

    if hotel_details
      hotel = Hotel.find_or_create_by(hotelNo: hotel_details['hotelNo']) do |h|
        h.name = hotel_details['hotelName']
        h.address = hotel_details['address1'] + hotel_details['address2']
        # 必要に応じて他の属性を設定
      end

      current_user.bookmark(hotel)
      redirect_to hotels_path, success: 'お気に入りに追加しました'
    else
      redirect_to hotels_path, alert: 'ホテルが見つかりませんでした'
    end
  end

  def destroy
    hotel = current_user.bookmarks.find(params[:id]).hotel
    current_user.unbookmark(hotel)
    redirect_to hotels_path, success: 'お気に入りを解除しました', status: :see_other
  end
end
