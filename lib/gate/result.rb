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
      hash.reduce({}) do |result, (k, v)|
        if v.kind_of?(Hash)
          nested = _errors(v)

          if nested.any?
            result[k] = nested
          end
        else
          result[k] = v
        end

        result
      end
    end
  end
end
