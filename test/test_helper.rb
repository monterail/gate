# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require "simplecov"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "gate"

require_relative "../test/dummy/config/environment"
require "rails/test_help"

require "minitest/autorun"
