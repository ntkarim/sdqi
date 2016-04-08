require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestAddFilter
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.cache_classes = true
    config.consider_all_requests_local = false
    config.action_controller.perform_caching = true
    config.serve_static_files = true
    config.assets.compress = true
    config.assets.compile = true
    config.assets.precompile += %w( style.css)
    config.assets.precompile += %w( animate.css)
    config.assets.precompile += %w( bootstrap.min.css)
    config.assets.precompile += %w( font-awesome.min.css)
    config.assets.precompile += %w( nivo-lightbox.css)
    config.assets.precompile += %w( nivo-lightbox-theme.css)
    config.assets.precompile += %w( owl.carousel.css)
    config.assets.precompile += %w( owl.theme.css)
    config.assets.precompile += %w( bootstrap.min.js)
    config.assets.precompile += %w( script.js)
    config.assets.precompile += %w( timer.js)
    config.assets.precompile += %w( wow.min.js)
    config.assets.precompile += %w( owl.carousel.js)
    config.assets.precompile += %w( nivo-lightbox.min.js)
    config.assets.precompile += %w( modernizr.custom.97074.js)
    config.assets.precompile += %w( jquery-2.1.3.min.js)
    config.assets.precompile += %w( jquery.hoverdir.js)
    config.assets.precompile.push(Proc.new do |path|
      File.extname(path).in? [
                                 '.html', '.erb', '.haml',                 # Templates
                                 '.png',  '.gif', '.jpg', '.jpeg', '.svg', # Images
                                 '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
                             ]
    end)
    config.active_record.raise_in_transactional_callbacks = true

  end
end
