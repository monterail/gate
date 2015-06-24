module Gate
  class Guard
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def verify(input)
      configuration.reduce(Result.new) do |result, (name, rule)|
        Result.new(_verify(input, name, rule, result))
      end
    end

    private

    def _verify(input, name, rule, result)
      case
      when input.key?(name)
        coerced = handle(input[name], name, rule)
        update(result, coerced)
      when configuration.required?(name)
        errors = result.errors.merge(name => :missing)
        update(result, errors: errors)
      else
        result.to_h
      end
    end

    def handle(input, name, rule)
      if rule.is_a?(Gate::Configuration)
        result = Gate::Guard.new(rule).verify(input)
        { attributes: { name => result.attributes },
          errors: { name => result.errors } }
      else
        coerce(input, name, rule)
      end
    end

    def coerce(input, name, rule)
      { attributes: { name => rule.coerce(input) } }
    rescue CoercionError
      # TODO: log error
      { errors: { name => :coercion_error } }
    end

    def update(result, attributes: {}, errors: {})
      { attributes: result.attributes.merge(attributes),
        errors: result.errors.merge(errors) }
    end
  end
end
