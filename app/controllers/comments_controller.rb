class CommentsController < ApplicationController
  before_action :require_login, only: [:create, :edit, :destroy]

  def create
    @hotel = Hotel.find(params[:hotel_id])
    @comment = @hotel.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @hotel, notice: 'コメントを作成しました'
    else
      redirect_to @hotel, alert: 'コメントの作成に失敗しました'
    end
  end

  def edit
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    redirect_to @comment.hotel, notice: 'コメントを削除しました'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
