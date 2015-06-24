module Gate
  class CoercionError < StandardError; end

  def self.rules(&block)
    configuration = Configuration.new(&block)

    Guard.new(configuration)
  end
end

require "axiom-types"
require "coercible"
require "forwardable"
require "set"

require "gate/coercer"
require "gate/configuration"
require "gate/guard"
require "gate/result"
require "gate/version"
