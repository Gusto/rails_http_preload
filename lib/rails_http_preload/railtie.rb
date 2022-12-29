# frozen_string_literal: true

require "rails"

module RailsHttpPreload
  class Railtie < Rails::Railtie
    initializer "rails_http_preload.middleware" do |app|
      app.config.middleware.use RailsHttpPreload::Middleware

      config.after_initialize do
        RailsHttpPreload.config.asset_host = app.config.asset_host
        RailsHttpPreload.config.default_asset_host_protocol = app.config.action_controller.default_asset_host_protocol
      end
    end
  end
end
