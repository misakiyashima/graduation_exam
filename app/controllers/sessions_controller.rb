class SessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])

    if @user.present?
      session[:user_id] = @user.id
      redirect_to root_path, notice: "ログインしました"
    else
      flash.now.alert = "ユーザー登録がありません"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "ログアウトしました"
  end
end
