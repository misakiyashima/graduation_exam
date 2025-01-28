class OauthCallbacksController < ApplicationController
  def twitter
    auth = request.env['omniauth.auth']

    if auth.nil? || !auth['provider'] || !auth['uid']
      Rails.logger.error "OmniAuth auth hash is nil. Request env: #{request.env.inspect}"
      redirect_to new_user_path, alert: '認証情報が取得できませんでした。'
      return
    end

    Rails.logger.debug "OmniAuth auth hash: #{auth.inspect}"

    begin
      user = User.from_omniauth(auth)
    rescue => e
      Rails.logger.error "Error during User.from_omniauth: #{e.message}"
      redirect_to new_user_path, alert: 'ログインに失敗しました。'
      return
    end

    if user.persisted?
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインに成功しました。'
    else
      Rails.logger.error "User not persisted: #{user.errors.full_messages.join(", ")}"
      redirect_to new_user_path, alert: 'ログインに失敗しました。'
    end
  end
end

