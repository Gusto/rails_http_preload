# frozen_string_literal: true

require_relative "rails_http_preload/version"
require_relative "rails_http_preload/middleware"
require_relative "rails_http_preload/railtie"

module RailsHttpPreload
  class Error < StandardError; end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield @config
  end

  class Configuration
    attr_accessor :additional_urls, :asset_host, :default_asset_host_protocol
  end
end
