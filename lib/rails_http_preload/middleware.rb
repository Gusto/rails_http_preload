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

      response[1]["Link"] = preconnect_header(response) if required?(response, ActionDispatch::Request.new(env))

      response
    end

    # TODO: Should we just add it to every response anyway and let the browser
    # figure it out?
    def required?(response, request)
      config.asset_host.present? && html?(response) && !already_connected?(request)
    end

    # Adding this header to, for example, a JSON response would be pointless
    # TODO: remove from Turbo frame responses too
    def html?(response)
      response[1]["Content-Type"].match?("html")
    end

    def current_asset_host
      ActionController::Base.helpers.compute_asset_host("", host: config.asset_host)
    end

    # If the asset host is equal to the request domain, no need to add.
    def already_connected?(request)
      request.base_url == current_asset_host
    end

    def preconnect_header(response)
      header = [
        current_asset_host,
        *config.additional_urls
      ].compact.map { |url| create_link_header(url) }.join(", ")

      if response[1]["Link"]
        "#{header}, #{response[1]["Link"]}"
      else
        header
      end
    end

    def create_link_header(url)
      "<#{url}>; rel=preconnect"
    end

    def config
      RailsHttpPreload.config
    end
  end
end
