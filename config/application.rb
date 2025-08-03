require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load environment variables from .env file
# if Rails.env.development? || Rails.env.test?
# Dotenv::Rails.load
# end

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    # config.autoload_lib(ignore: %w[assets tasks])

    # Add app/controllers to autoload paths
    # config.autoload_paths += ["#{config.root}/app/controllers", "#{config.root}/app/services", "#{config.root}/app/models"]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Add the following line to disable the raise on missing callback actions
    config.action_controller.raise_on_missing_callback_actions = false
    # config.eager_load_paths += ["#{config.root}/app/models"]
  end
end
