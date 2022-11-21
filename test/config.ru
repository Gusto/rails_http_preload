# frozen_string_literal: true

# This file is only used for manual testing, if you want to run the example app
# and run curl against it or something. Not actually used in the test suite.
# From the project root: $ puma test/config.ru
require_relative "app"

MyApp.initialize!
run MyApp
