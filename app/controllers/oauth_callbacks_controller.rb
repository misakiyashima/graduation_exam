class OauthCallbacksController < ApplicationController
  def twitter
    auth = request.env["omniauth.auth"]

    if auth.nil? || !auth["provider"] || !auth["uid"]
      redirect_to new_user_path, alert: "認証情報が取得できませんでした。"
      return
    end

    begin
      user = User.from_omniauth(auth)  #User.from_omniauth を使ってユーザー作成
    rescue => e
      redirect_to new_user_path, alert: "ログインに失敗しました。"
      return
    end
    
    #Sorceryのauto_login を使わず、sessionを直接操作→例外処理
    if user.persisted?
      session[:user_id] = user.id
      redirect_to root_path, notice: "ログインに成功しました。"
    else
      redirect_to new_user_path, alert: "ログインに失敗しました。"
    end
  end

  def google
    auth = request.env['omniauth.auth']
    #Googleはemailを返すためemailを保存できる
    user = User.find_or_create_by(provider: auth.provider, uid: auth.uid) do |u|
      u.email = auth.info.email
      u.name  = auth.info.name
      u.avatar_url = auth.info.image
      u.password = SecureRandom.hex(10) # Sorcery用
    end
#Sorceryのauto_loginを使う.Twitterと異なり、例外処理不要
    auto_login(user)
    redirect_to root_path, notice: "Googleでログインしました"
  end

end
