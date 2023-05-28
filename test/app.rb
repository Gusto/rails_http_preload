# frozen_string_literal: true

# This test app follows the same structure of config/application.rb,
# config/environment.rb and config.ru that exists in any Rails app. Here,
# we're just doing it in one file.
#
# We're only going to load the parts of Rails we need for this test. Usually,
# you would just require "rails/all", requiring all of the below parts at once.
require "action_controller/railtie"

class MyApp < Rails::Application
  config.root = __dir__
  config.hosts << "example.org"
  secrets.secret_key_base = "secret_key_base"
  config.eager_load = true

  config.asset_host = "https://cdn.example.org"
  config.logger = Logger.new(nil)
  Rails.logger  = config.logger

  routes.append do
    get "/" => "hello#world"
    get "/json" => "hello#json"
    get "/existing_link_header" => "hello#existing_link_header"
  end
end

class HelloController < ActionController::Base
  def world
    render html: "<p>Hello world!</p>"
  end

  def json
    render json: "Hello world!"
  end

  def existing_link_header
    response.set_header("Link", "<https://other.example.org>; rel=preconnect")
    render html: "<p>Hello world!</p>"
  end
end
