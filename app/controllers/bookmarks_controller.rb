class BookmarksController < ApplicationController
  def create
    hotel_no = params[:hotel_id]
    hotel_service = HotelService.new(ENV['RAKUTEN_API_KEY'])  # APIキーを渡す
    hotel_details = hotel_service.get_hotel_details(hotel_no)
    
    if hotel_details.present?
      # ホテル情報をデータベースに保存
      hotel_service.save_hotel_to_db(hotel_details)
      
      # ブックマークの存在確認
      unless current_user.bookmarks.exists?(hotel_id: params[:hotel_id])
        bookmark = current_user.bookmarks.create(
          hotel_id: params[:hotel_id],
          hotel_no: hotel_details['hotelNo'],
          hotel_name: hotel_details['hotelName'],
          hotel_information_url: hotel_details['hotelInformationUrl']
        )
        
        Rails.logger.info "Bookmark Errors: #{bookmark.errors.full_messages}"
        if bookmark.persisted?
          redirect_to hotels_path, success: 'お気に入りに追加しました'
        else
          redirect_to hotels_path, alert: "お気に入りの追加に失敗しました: #{bookmark.errors.full_messages.join(', ')}"
        end
      else
        redirect_to hotels_path, alert: 'このホテルは既にお気に入りに追加されています'
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

  private

  def bookmark_params
    params.permit(:user_id, :hotel_id, :hotel_no, :hotel_name, :hotel_information_url)
  end
end

