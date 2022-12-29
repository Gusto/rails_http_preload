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

      header = PreconnectHeader.new(env, response)
      response[1]["Link"] = header.to_s if header.required?

      response
    end

    class PreconnectHeader
      attr_reader :request, :response

      include ActionView::Helpers::AssetUrlHelper

      def initialize(env, response)
        @request = ActionDispatch::Request.new(env)
        @response = response
      end

      def required?
        response[1]["Content-Type"].match?("html") &&
          compute_asset_host(config.asset_host) != compute_asset_host("", host: request.domain)
      end

      def to_s
        [
          create_link_header(compute_asset_host(config.asset_host)),
          *config.additional_urls&.map { |url| create_link_header(url) }
        ].join(", ")
      end

      def create_link_header(url)
        "<#{url}>; rel=preconnect"
      end

      def config
        RailsHttpPreload.config
      end
    end
  end
end
