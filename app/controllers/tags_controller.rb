class TagsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    hotel_tag = HotelTag.new(hotel_tag_params)
    if hotel_tag.save
      redirect_to root_path, notice: "タグが追加されました"
    else
      redirect_to root_path, alert: "タグの追加に失敗しました"
    end
  end

  private

  def hotel_tag_params
    params.require(:hotel_tag).permit(:hotel_id, :tag_id)
  end
end
