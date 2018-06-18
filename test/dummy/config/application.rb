# frozen_string_literal: true

require_relative "boot"

require "rails"
require "action_controller/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.load_defaults 5.2
  end
end
