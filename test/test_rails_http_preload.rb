# frozen_string_literal: true

require "test_helper"

class TestRailsHttpPreload < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RailsHttpPreload::VERSION
  end

  # It adds a link header to the response in a way we expect
  def test_it_adds_a_link_header
    assert false
  end

  # If the response is not HTML, don't add the header
  def test_it_doesnt_add_a_link_header_if_not_html
    assert false
  end

  # If we are responding from the same domain as the asset_host, don't add the header
  def test_it_doesnt_add_a_link_header_if_same_domain
    assert false
  end

  # That link header changes if the asset host changes
  def test_it_adds_header_based_on_asset_host
    assert false
  end

  # We can add 2 or more additional domains using config
  def test_it_adds_header_based_on_configured_domains
    assert false
  end
end
