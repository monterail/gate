module Gate
  class Result
    attr_reader :attributes

    def initialize(attributes: {}, errors: {})
      @attributes = attributes
      @errors = errors
    end

    def valid?
      errors.empty?
    end

    def errors
      _errors(@errors)
    end

    def to_h
      {
        attributes: attributes,
        errors: @errors
      }
    end

    private

    def _errors(hash)
      hash.each_with_object({}) do |(k, v), result|
        if v.is_a?(Hash)
          nested = _errors(v)

          result[k] = nested if nested.any?
        else
          result[k] = v
        end
      end
    end
  end
end
