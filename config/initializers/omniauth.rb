Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "wRFHOrusnaCk9vfRuuVTwew8B", "Y5pQopgpzcylCqxmjmamAUSP4dr1fgWuTEbL0KXN0eo53sTK87"
end

OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true
