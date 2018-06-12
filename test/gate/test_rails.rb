# frozen_string_literal: true

require "test_helper"

module Gate
  class RailsTest < ActionDispatch::IntegrationTest
    def test_valid_params
      get "/foo", params: { "foo" => "FOO", "bar" => "" }

      assert_response :success
    end

    def test_invalid_params
      get "/foo", params: { "bar" => "BAR" }

      assert_response :bad_request
    end
  end
end
