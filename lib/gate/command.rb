module Gate
  module Command
    SchemaAlreadyRegistered = Class.new(StandardError)
    SchemaNotDefined = Class.new(StandardError)

    class InvalidCommand < StandardError
      attr_reader :errors

      def initialize(errors)
        @errors = errors
        super("Invalid command")
      end
    end

    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:attr_reader, :result)
    end

    def initialize(data)
      @result = data
    end

    module ClassMethods
      def schema(&block)
        if block_given?
          raise SchemaAlreadyRegistered if @schema
          @schema = Dry::Validation.Form(&block)
          @schema.rules.keys.each do |name|
            define_method(name) do
              result[name]
            end
          end
        else
          raise SchemaNotDefined unless @schema
          @schema
        end
      end

      def with(input)
        result = schema.(input)
        raise InvalidCommand, result.messages if result.failure?
        new result.output
      end
    end
  end
end
