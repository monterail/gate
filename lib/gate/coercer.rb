module Gate
  class Coercer
    def initialize(engine, type)
      unless Axiom::Types.const_defined?(type)
        fail CoercionError, "Doesn't know how to coerce into #{type}"
      end

      @engine = engine
      @type = type
      @coercion_method = Axiom::Types.const_get(type).coercion_method
    end

    def coerce(input)
      engine[String].public_send(coercion_method, input)
    rescue Coercible::UnsupportedCoercion
      raise CoercionError, "Doesn't know how to coerce #{input} into #{type}"
    end

    private

    attr_reader :engine, :type, :coercion_method
  end
end
