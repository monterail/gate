# frozen_string_literal: true

require "test_helper"

module Gate
  class RailsTest < ActionDispatch::IntegrationTest
    def test_valid_params
      get "/with_validation", params: { "foo" => "FOO", "bar" => "" }

      assert_response :success
    end

    def test_invalid_params
      get "/with_validation", params: { "bar" => "BAR" }

      assert_response :bad_request
    end

    def test_without_validation
      get "/without_validation", params: { "foo" => "FOO" }

      assert_response :success
    end

    def test_missing_schema
      get "/with_error", params: { "foo" => "FOO" }

      assert false, "SchemaNotDefined should be raised"
    rescue Gate::Rails::SchemaNotDefined => e
      assert_equal e.message, "Missing `with_error` schema"
    end
  end
end
