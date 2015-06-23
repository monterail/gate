module Gate
  class Configuration
    extend Forwardable

    attr_reader :coercer
    attr_reader :required_set, :optional_set, :nested_set
    attr_reader :rules

    def_delegator :@rules, :reduce

    def initialize(coercer = Coercible::Coercer.new, &block)
      @coercer = coercer
      @required_set = Set.new
      @optional_set = Set.new
      @nested_set = Set.new
      @rules = {}

      instance_eval(&block)
    end

    def required?(name)
      required_set.include?(name)
    end

    def coerce(input)
      Gate::Guard.new(self).verify(input)
    end

    private

    def required(name, type = :String, &block)
      required_set.add(name)
      register(name, type, &block)
    end

    def optional(name, type = :String, &block)
      optional_set.add(name)
      register(name, type, &block)
    end

    def register(name, type, &block)
      @rules[name] = setup_rule(name, type, &block)
    end

    def setup_rule(name, type, &block)
      if block_given?
        nested_set.add(name)
        Configuration.new(coercer, &block)
      else
        Coercer.new(coercer, type)
      end
    end
  end
end
