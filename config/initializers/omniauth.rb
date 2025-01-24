Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['wRFHOrusnaCk9vfRuuVTwew8B'], ENV['Y5pQopgpzcylCqxmjmamAUSP4dr1fgWuTEbL0KXN0eo53sTK87']
  OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure ##コールバックに失敗した時のアクション設定
}
end

OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true
