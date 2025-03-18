require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

RSpec.configure do |config|
  # ActiveRecordの設定を完全に無効化
  config.use_active_record = false

  # 自動的にファイルロケーションからスペックタイプを推論
  config.infer_spec_type_from_file_location!

  # Railsに関連するバックトレースをフィルタリング
  config.filter_rails_from_backtrace!
end
