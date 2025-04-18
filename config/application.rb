require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TruckTransport
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    config.api_only = true
    config.session_store :cookie_store, key: '_transport_app_session'  # Enable sessions
    config.middleware.use ActionDispatch::Cookies  # Allow cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: '_transport_app_session'

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    config.action_mailer.default_url_options = { host: 'http://localhost:3000' }
    
    config.active_storage.analyze_after_uploads = false

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "UTC"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
