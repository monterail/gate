# frozen_string_literal: true

module Gate
  InvalidCommand = Class.new(StandardError)
end

require "dry-validation"

require "gate/command"
require "gate/rails"
require "gate/version"
