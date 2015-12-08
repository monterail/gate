module Gate
  class Coercer
    def initialize(engine, type, allow_nil: false)
      @engine = engine
      @type = type
      @allow_nil = allow_nil
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

    attr_reader :engine, :type

    def detect_input_type(input)
      case input
      when TrueClass, FalseClass, Array, Hash, Any
        input.class
      else
        String
      end
    end

    def coercion_method
      if type == :Any
        "to_any"
      elsif Axiom::Types.const_defined?(type)
        Axiom::Types.const_get(type).coercion_method
      else
        fail CoercionError, "Doesn't know how to coerce into #{type}"
      end
    end
  end
end
