class BookmarksController < ApplicationController
  def create
    hotel = Hotel.find(params[:hotel_id])
    current_user.bookmark(hotel)
    redirect_to hotels_path, success:'成功'
  end

  def dastroy
  　hotel = current_user.bookmarks.find(params[:id]).hotel
    current_user.unbookmark(hotel)
    redirect_to hotels_path, success:'成功', status: :see_other
  end
end
