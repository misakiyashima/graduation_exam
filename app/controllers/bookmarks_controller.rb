class BookmarksController < ApplicationController

  def create
    hotel = Hotel.find(params[:hotel_id])
    current_user.bookmark(hotel)
    redirect_to hotels_path, success:'お気に入りに追加しました'
  end

  def destroy
  　hotel = current_user.bookmarks.find(params[:id]).hotel
    current_user.unbookmark(hotel)
    redirect_to hotels_path, success:'お気に入りを解除しました', status: :see_other
  end
end
