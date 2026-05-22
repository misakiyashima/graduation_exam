class OauthCallbacksController < ApplicationController
  def twitter
    auth = request.env["omniauth.auth"]

    if auth.nil? || !auth["provider"] || !auth["uid"]
      redirect_to new_user_path, alert: "認証情報が取得できませんでした。"
      return
    end

    begin
      user = User.from_omniauth(auth)  # User.from_omniauth を使ってユーザー作成
    rescue => e
      redirect_to new_user_path, alert: "ログインに失敗しました。"
      return
    end

    # Sorceryのauto_login を使わず、sessionを直接操作→例外処理
    if user.persisted?
      session[:user_id] = user.id
      redirect_to root_path, notice: "ログインに成功しました。"
    else
      redirect_to new_user_path, alert: "ログインに失敗しました。"
    end
  end

  def google
    auth = request.env["omniauth.auth"] # googleが返したJson形式のデータが入っている

    if auth.nil? || !auth["provider"] || !auth["uid"]
      redirect_to new_user_path, alert: "認証情報が取得できませんでした。"
      return
    end
    # ユーザー作成ロジックは共通で User.from_omniauth に集約
    user = User.from_omniauth(auth)
    # Sorceryのauto_login を使う(レスポンスが安定しているため)
    auto_login(user)
    redirect_to root_path, notice: "Googleでログインしました"
  end
end
