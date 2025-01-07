class BookmarksController < ApplicationController
  def create
    hotel_no = params[:hotel_id]
    Rails.logger.info "Hotel ID: #{hotel_no}" 
    hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])  # APIキーを渡す
    hotel_details = hotel_service.get_hotel_details(hotel_no)

    if hotel_details.present?
      bookmark = current_user.bookmarks.create(
        hotel_no: hotel_details['hotelNo'],
        hotel_name: hotel_details['hotelName'],
        hotel_information_url: hotel_details['hotelInformationUrl']
      )
      if bookmark.persisted?
        redirect_to hotels_path, success: 'お気に入りに追加しました'
      else
        redirect_to hotels_path, alert: 'お気に入りの追加に失敗しました'
      end
    else
      redirect_to hotels_path, alert: 'ホテルが見つかりませんでした'
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find(params[:id])
    bookmark.destroy
    redirect_to hotels_path, success: 'お気に入りを解除しました', status: :see_other
  end
end
