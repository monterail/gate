module Gate
  class Coercer
    PRIMITIVES = [TrueClass, FalseClass, Array, Hash, Numeric]

    def initialize(engine, type, allow_nil: false)
      unless coercible?(type)
        fail CoercionError, "Doesn't know how to coerce into #{type}"
      end

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

    def coercible?(type)
      type == :Any or Axiom::Types.const_defined?(type)
    end

    def detect_input_type(input)
      case input
      when *PRIMITIVES, Any
        input.class
      else
        String
      end
    end

    def coercion_method
      return :to_any if type == :Any

      Axiom::Types.const_get(type).coercion_method
    end
  end
end
