# frozen_string_literal: true

require "forwardable"

module Gate
  module Command
    extend Forwardable

    def_delegator :result, :to_h

    SchemaAlreadyRegistered = Class.new(StandardError)
    SchemaNotDefined = Class.new(StandardError)

    attr_reader :result

    class InvalidCommand < StandardError
      attr_reader :errors

      def initialize(errors)
        @errors = errors
        super("Invalid command")
      end

      def full_message
        errors.values.join(", ")
      end
    end

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    def initialize(data)
      @result = data
    end

    module ClassMethods
      # rubocop:disable Metrics/MethodLength
      def schema(&block)
        if block_given?
          raise SchemaAlreadyRegistered if instance_variable_defined?(:@schema)
          @schema = Dry::Validation.Params(&block)
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
      # rubocop:enable Metrics/MethodLength

      def with(input)
        result = schema.call(input)
        raise InvalidCommand, result.messages(full: true) if result.failure?
        new result.output
      end
    end
  end
end
