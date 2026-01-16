class TagsController < ApplicationController
  before_action :require_login, only: [ :new, :create, :destroy ]
  before_action :set_tags, only: [ :new, :create ]

  def new
    @hotel_tag = HotelTag.new
    @hotel_id = params[:hotel_id]
  end

  def create
    hotel_no = hotel_tag_params[:hotel_id]
    @hotel_id = hotel_no
    @frame_id = "hotel_#{hotel_no}_tags"

    hotel_service = HotelService.new(ENV["RAKUTEN_API_KEY"])
    hotel_info = hotel_service.get_hotel_details(hotel_no)

    if hotel_info.present?
      @hotel_record = hotel_service.save_hotel_to_db(hotel_info)
    else
      redirect_to root_path, alert: "無効なホテルIDです"
      return
    end

    tag = Tag.find_or_create_by(name: params[:hotel_tag][:tag_id])
    @hotel_tag = HotelTag.new(
      hotel_id: @hotel_record.id,
      tag_id: tag.id,
      user_id: current_user.id
    )

    if @hotel_tag.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to params[:return_to] || root_path }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @hotel_tag = HotelTag.find(params[:id])
    @hotel_tag.destroy

    respond_to do |format|
      format.html do
        redirect_to request.referer || root_path, notice: "タグが削除されました"
      end

      format.turbo_stream do
      end
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
