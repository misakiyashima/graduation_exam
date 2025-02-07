class TagsController < ApplicationController
  before_action :require_login, only: [:new, :create, :destroy]
  before_action :set_tags, only: [:new, :create]

  def new
    @hotel_tag = HotelTag.new
    @hotel_id = params[:hotel_id]
  end

  def create
    @hotel_tag = HotelTag.new(hotel_tag_params)
    if @hotel_tag.save
      redirect_to root_path, notice: "タグが追加されました"
    else
      @hotel_id = @hotel_tag.hotel_id
      render :new, alert: "タグの追加に失敗しました"
    end
  end

  def destroy
    hotel_tag = HotelTag.find(params[:id])
    if hotel_tag.destroy
      redirect_to root_path, notice: "タグが削除されました"
    else
      redirect_to root_path, alert: "タグの削除に失敗しました"
    end
  end

  private

  def hotel_tag_params
    params.require(:hotel_tag).permit(:hotel_id, :tag_id)
  end

  def set_tags
    @tags = Tag.all
  end
end
