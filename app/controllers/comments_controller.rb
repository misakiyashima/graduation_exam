class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to root_path, notice: 'コメントを作成しました'
    else
      redirect_to root_path, alert: 'コメントの作成に失敗しました'
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
