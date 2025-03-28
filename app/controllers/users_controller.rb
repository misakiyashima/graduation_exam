class UsersController < ApplicationController
  before_action :require_login, only: [:mypage]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "登録が完了しました。"
      redirect_to root_path
    else
      flash.now[:alert] = "登録に失敗しました。もう一度確認をお願いします"
      render :new
    end
  end

  def mypage
    @user = current_user
    @bookmarks = @user.bookmarks.includes(:hotel)
    @comments = @user.comments.includes(:hotel)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
