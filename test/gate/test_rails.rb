# frozen_string_literal: true

require "test_helper"

module Gate
  class RailsTest < ActionDispatch::IntegrationTest
    def test_hook_with_valid_params
      get "/with_validation", params: {"foo" => "FOO", "bar" => ""}

      assert_response :success
      assert_equal @response.body, {foo: "FOO", bar: nil}.inspect
    end

    def test_class_with_valid_params
      get "/with_class_validation", params: {"foo" => "FOO", "bar" => ""}

      assert_response :success
      assert_equal @response.body, {foo: "FOO", bar: nil}.inspect
    end

    def test_default_invalid_params
      get "/with_validation", params: {"bar" => "BAR"}

      assert_response :bad_request
    end

    def test_without_validation
      get "/without_validation", params: {"foo" => "FOO"}

      assert_response :success
    end

    def test_missing_schema
      get "/with_error", params: {"foo" => "FOO"}

      assert false, "SchemaNotDefined should be raised"
    rescue Gate::Rails::ContractNotDefined => e
      assert_equal e.message, "Missing `with_error` contract"
    end

    def test_custom_invalid_params
      get "/with_custom_invalid", params: {"bar" => "BAR"}

      assert_response :bad_request
      assert_equal @response.body, {foo: ["is missing"]}.inspect
    end
  end
end
