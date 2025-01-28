class OauthCallbacksController < ApplicationController
  def twitter
    auth = request.env['omniauth.auth']

    if auth.nil? || !auth['provider'] || !auth['uid']
      redirect_to new_user_path, alert: '認証情報が取得できませんでした。'
      return
    end

    begin
      user = User.from_omniauth(auth)
    rescue => e
      redirect_to new_user_path, alert: 'ログインに失敗しました。'
      return
    end

    if user.persisted?
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインに成功しました。'
    else
      redirect_to new_user_path, alert: 'ログインに失敗しました。'
    end
  end
end
