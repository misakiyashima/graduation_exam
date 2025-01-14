Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "74HqoBpH32Cln9bJxbZ5DfE60", "E9AfkuAKE2lucCCBImLfIkI3UA25WanFf2SFYZhbqCHaceJ26l"
  OmniAuth.config.allowed_request_methods = [:post, :get]
end
