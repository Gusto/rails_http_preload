# frozen_string_literal: true

# This test app follows the same structure of config/application.rb,
# config/environment.rb and config.ru that exists in any Rails app. Here,
# we're just doing it in one file.
#
# We're only going to load the parts of Rails we need for this test. Usually,
# you would just require "rails/all", requiring all of the below parts at once.
require "action_controller/railtie"

class MyApp < Rails::Application
  routes.append { root "hello#world" }

  # Eager load. Production style.
  config.eager_load = true
end

class HelloController < ActionController::Base
  def world
    render html: "<p>Hello world!</p>"
  end
end
