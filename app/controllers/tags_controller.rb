class TagsController < ApplicationController
  before_action :require_login, only: [:new, :create, :destroy]
  before_action :set_tags, only: [:new, :create]

  def new
    @hotel_tag = HotelTag.new
    @hotel_id = params[:hotel_id]
  end

  def create
  hotel_id = hotel_tag_params[:hotel_id]
  return_to = params[:return_to]
  tag_name = params[:hotel_tag][:tag_id]

  # 楽天APIからホテル情報を取得
  hotel_service = HotelService.new(ENV["RAKUTEN_API_KEY"])
  hotel_info = hotel_service.get_hotel_details(hotel_id)

  if hotel_info.present?
    # ホテル情報を保存
    hotel_service.save_hotel_to_db(hotel_info)
  else
    redirect_to root_path, alert: "無効なホテルIDです"
    return
  end

  # タグ作成処理
  tag = Tag.find_or_create_by(name: tag_name)
  @hotel_tag = HotelTag.new(hotel_id: hotel_id, tag_id: tag.id)

  @hotel_tag.user_id = current_user.id if current_user

  if @hotel_tag.save
    redirect_to return_to.present? ? return_to : root_path, notice: "タグが追加されました"

  else
    @hotel_id = hotel_id
    set_tags
    render :new, alert: "タグの追加に失敗しました"
  end
  end

  def destroy
    hotel_tag = HotelTag.find(params[:id])
    if hotel_tag.destroy
      redirect_to root_path, notice: "タグが削除されました", status: :see_other
    else
      redirect_to root_path, alert: "タグの削除に失敗しました", status: :see_other
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
