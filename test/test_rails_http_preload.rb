# frozen_string_literal: true

require "test_helper"

class TestRailsHttpPreload < Minitest::Test
  include Rack::Test::Methods

  def test_that_it_has_a_version_number
    refute_nil ::RailsHttpPreload::VERSION
  end

  def app
    MyApp
  end

  def test_response_is_ok
    get '/'

    assert last_response.ok?
    assert_equal "&lt;p&gt;Hello world!&lt;/p&gt;", last_response.body
  end

  # It adds a link header to the response in a way we expect
  def test_it_adds_a_link_header
    get '/'

    assert_equal "<https://cdn.example.org>; rel=preconnect", last_response.headers["link"]
  end

  # If the response is not HTML, don't add the header
  def test_it_doesnt_add_a_link_header_if_not_html
    get '/json'

    assert_nil last_response.headers["link"]
  end

  # If we are responding from the same domain as the asset_host, don't add the header
  def test_it_doesnt_add_a_link_header_if_same_domain
    MyApp.config.asset_host = 'example.org'
    get '/'

    assert_nil last_response.headers["link"]
  end

  # That link header changes if the asset host changes
  def test_it_adds_header_based_on_asset_host
    MyApp.config.asset_host = 'cdn2.example.org'
    get '/'

    assert_equal "<https://cdn2.example.org>; rel=preconnect", last_response.headers["link"]
  end

  # We can add 2 or more additional domains using config
  def test_it_adds_header_based_on_configured_domains
    RailsHttpPreload.config.additional_urls = %w[https://graphql.example.org https://images.example.org]
    get '/'

    assert_equal "<https://cdn.example.org>; rel=preconnect, <https://graphql.example.org>; rel=preconnect, <https://images.example.org>; rel=preconnect", last_response.headers["link"]
  end
end
