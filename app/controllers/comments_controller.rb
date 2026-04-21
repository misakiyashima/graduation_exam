class CommentsController < ApplicationController
  before_action :set_comment, only: [ :edit, :update, :destroy ]

  def index
    @comments = current_user.comments.includes(:hotel)
  end

  def all
    @comments = Comment.includes(:user, :hotel).order(created_at: :desc)
  end

  def create
    @hotel_record = Hotel.find(params[:hotel_id])  # ← 内部IDで取得

    @comment = Comment.new(comment_params)
    @comment.user  = current_user
    @comment.hotel = @hotel_record

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to hotel_path(@hotel_record.id), notice: "コメントが投稿されました。" }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to hotel_path(@hotel_record.id), alert: "コメントの投稿に失敗しました。" }
      end
    end
  end


  def edit
  end

  def update
    @hotel = @comment.hotel

    if @comment.update(comment_params)
      redirect_to hotel_path(@comment.hotel.id), notice: "コメントが更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @hotel = @comment.hotel

    @comment.destroy
    redirect_to hotel_path(@comment.hotel.id), notice: "コメントが削除されました。"
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
