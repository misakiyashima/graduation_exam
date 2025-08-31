module ApplicationHelper
  # params[:return_to] が同一ホスト内のパスなら返し、そうでなければ fallback を返す
  def safe_return_to(url, fallback)
    uri = URI.parse(url.to_s)
    if uri.host.nil? && uri.path.start_with?("/") && uri.scheme.nil?
      uri.to_s
    else
      fallback
    end
  rescue URI::InvalidURIError
    fallback
  end
end
