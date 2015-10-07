module Gate
  class Coercer
    def initialize(engine, type, allow_nil: false)
      unless Axiom::Types.const_defined?(type)
        fail CoercionError, "Doesn't know how to coerce into #{type}"
      end

      @engine = engine
      @type = type
      @allow_nil = allow_nil
      @coercion_method = Axiom::Types.const_get(type).coercion_method
    end

    def coerce(input)
      engine[detect_input_type(input)].public_send(coercion_method, input)
    rescue Coercible::UnsupportedCoercion
      raise CoercionError, "Doesn't know how to coerce #{input} into #{type}"
    end

    def allow_nil?
      @allow_nil
    end

    private

    attr_reader :engine, :type, :coercion_method

    def detect_input_type(input)
      case input
      when TrueClass, FalseClass, Array, Hash
        input.class
      else
        String
      end
    end
  end
end
