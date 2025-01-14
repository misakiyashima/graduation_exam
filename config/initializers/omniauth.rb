Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "TXJzVHY3dmM2WC0wTE1CVjNUclg6MTpjaQ", "kt8B10o9oFL4z7lYKTFMHsRkys03zT3_nHKdU-u4Pb21BOTlw_"
  OmniAuth.config.allowed_request_methods = [:post, :get]
end
