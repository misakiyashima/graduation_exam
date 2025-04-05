require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # クラスのキャッシュを有効化（Springが無効な場合を想定）。
  config.cache_classes = true

  # アプリケーション全体のロードを制御。
  # CI環境以外では通常はfalseで十分。
  config.eager_load = ENV["CI"].present?

  # 公開ファイルサーバーの設定。
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # エラーの詳細を表示し、キャッシュを無効化。
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # エラー例外時のテンプレート表示を無効化。
  config.action_dispatch.show_exceptions = false

  # フォージェリープロテクションを無効化。
  config.action_controller.allow_forgery_protection = false

  # 一時ディレクトリを使用してファイルを保存。
  config.active_storage.service = :test

  # メーラー設定。
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test

  # 標準エラー出力に非推奨警告を表示。
  config.active_support.deprecation = :stderr

  # 非許可の非推奨警告に対して例外を発生。
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # 必要に応じて追加の設定。
  # config.i18n.raise_on_missing_translations = true
  # config.action_view.annotate_rendered_view_with_filenames = true
end

