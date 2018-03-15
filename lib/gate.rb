module Gate
  InvalidCommand = Class.new(StandardError)
end

require "dry-validation"

require "gate/command"
require "gate/version"
