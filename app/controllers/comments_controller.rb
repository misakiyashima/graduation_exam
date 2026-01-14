class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]

  def index
    @comments = current_user.comments.includes(:hotel)
  end

  def all
    @comments = Comment.includes(:user, :hotel).order(created_at: :desc)
  end

  def create
    client = HotelService.new(ENV["RAKUTEN_API_KEY"])
    hotel_info = client.get_hotel_details(params[:hotel_id])

    unless hotel_info
      flash[:alert] = "ホテルが見つかりませんでした。"
      redirect_to hotels_path
      return
    end

    # 内部IDを生成 or 取得
    hotel_record = client.save_hotel_to_db(hotel_info)

    @comment = Comment.new(comment_params)
    @comment.user  = current_user
    @comment.hotel = hotel_record # ← 内部IDで紐づける

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to hotel_path(hotel_record.external_id), notice: "コメントが投稿されました。" }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to hotel_path(hotel_record.external_id), alert: "コメントの投稿に失敗しました。" }
      end
    end
  end

  def edit
  end

  def update
    @hotel = @comment.hotel

    if @comment.update(comment_params)
      redirect_to hotel_path(@hotel), notice: "コメントが更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @hotel = @comment.hotel

    @comment.destroy
    redirect_to hotel_path(@hotel), notice: "コメントが削除されました。"
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
