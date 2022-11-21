# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "rails_http_preload"

require "minitest/autorun"
require_relative "app"
require "rack/test"
