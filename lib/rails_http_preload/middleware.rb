# frozen_string_literal: true

require "action_view/helpers/asset_url_helper"
require "active_support/concern"
require "action_dispatch"

module RailsHttpPreload
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      response = @app.call(env)

      response[1]["Link"] = preconnect_header if required?(response, ActionDispatch::Request.new(env))

      response
    end

    # TODO: Should we just add it to every response anyway and let the browser
    # figure it out?
    def required?(response, request)
      html?(response) &&
        !already_connected?(request)
    end

    # Adding this header to, for example, a JSON response would be pointless
    # TODO: remove from Turbo frame responses too
    def html?(response)
      response[1]["Content-Type"].match?("html")
    end

    # If the asset host is equal to the request domain, no need to add.
    def already_connected?(request)
      protocol = request.protocol.gsub("://", "")
      ActionController::Base.helpers.compute_asset_host("", host: config.asset_host) ==
        ActionController::Base.helpers.compute_asset_host("", { protocol: protocol, host: request.domain })
    end

    def preconnect_header
      [
        ActionController::Base.helpers.compute_asset_host("", host: config.asset_host),
        *config.additional_urls
      ].compact.map { |url| create_link_header(url) }.join(", ")
    end

    def create_link_header(url)
      "<#{url}>; rel=preconnect"
    end

    def config
      RailsHttpPreload.config
    end
  end
end
