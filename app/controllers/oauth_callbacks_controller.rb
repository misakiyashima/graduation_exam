class OauthCallbacksController < ApplicationController
  def twitter
    auth = request.env['omniauth.auth']
    if auth.nil? || !auth['provider'] || !auth['uid']
      Rails.logger.error "Invalid auth hash: #{auth.inspect}"
      redirect_to new_user_path, alert: '認証情報が取得できませんでした。'
      return
    end

    user = User.from_omniauth(auth)

    if user.persisted?
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインに成功しました。'
    else
      redirect_to new_user_path, alert: 'ログインに失敗しました。'
    end
  end
end
