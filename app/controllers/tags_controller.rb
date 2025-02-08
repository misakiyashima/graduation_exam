class TagsController < ApplicationController
  before_action :require_login, only: [:new, :create, :destroy]
  before_action :set_tags, only: [:new, :create]

  def new
    @hotel_tag = HotelTag.new
    @hotel_id = params[:hotel_id]
  end

  def create
    tag_name = params[:hotel_tag][:tag_id]
    tag = Tag.find_or_create_by(name: tag_name)
    @hotel_tag = HotelTag.new(hotel_id: hotel_tag_params[:hotel_id], tag_id: tag.id)

    Rails.logger.info "HotelTag Parameters: #{hotel_tag_params.merge(tag_id: tag.id).inspect}"
    Rails.logger.info "HotelTag Valid?: #{@hotel_tag.valid?}"
    Rails.logger.info "HotelTag Errors: #{@hotel_tag.errors.full_messages}"

    if @hotel_tag.save
      redirect_to root_path, notice: "タグが追加されました"
    else
      @hotel_id = @hotel_tag.hotel_id
      set_tags
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
    params.require(:hotel_tag).permit(:hotel_id)
  end

  def set_tags
    @tags = Tag.all
  end
end
