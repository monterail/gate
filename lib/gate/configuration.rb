module Gate
  class Configuration
    extend Forwardable

    attr_reader :coercer
    attr_reader :required_set, :optional_set, :nested_set
    attr_reader :rules

    def_delegator :@rules, :reduce

    def initialize(coercer: Coercible::Coercer.new, allow_nil: false, &block)
      @coercer = coercer
      @required_set = Set.new
      @optional_set = Set.new
      @nested_set = Set.new
      @rules = {}
      @allow_nil = allow_nil

      instance_eval(&block)
    end

    def required?(name)
      required_set.include?(name)
    end

    def allow_nil?
      @allow_nil
    end

    private

    def required(name, type = :String, allow_nil: false, &block)
      required_set.add(name)
      register(name, type, allow_nil: allow_nil, &block)
    end

    def optional(name, type = :String, allow_nil: false,  &block)
      optional_set.add(name)
      register(name, type, allow_nil: allow_nil, &block)
    end

    def register(name, type, allow_nil:, &block)
      @rules[name] = setup_rule(name, type, allow_nil: allow_nil, &block)
    end

    def setup_rule(name, type, allow_nil:, &block)
      if block_given?
        nested_set.add(name)
        Configuration.new(coercer: coercer, allow_nil: allow_nil, &block)
      else
        Coercer.new(coercer, type, allow_nil: allow_nil)
      end
    end
  end
end
