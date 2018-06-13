# frozen_string_literal: true

require "pry"

module Gate
  module Rails
    attr_reader :validated_params

    SchemaNotDefined = Class.new(StandardError)

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      mattr_accessor :params_schemas, default: {}

      def fetch_params_schema(schema_name)
        params_schemas.fetch(schema_name) do
          raise SchemaNotDefined, "Missing `#{schema_name}` schema"
        end
      end

      def def_schema(&block)
        @_schema = Dry::Validation.Params(&block)
      end

      def method_added(method_name)
        return unless @_schema

        params_schemas[method_name] = @_schema
        @_schema = nil
      end
    end

    def validate_params
      result = params_schema.call(request.params)

      if result.success?
        @validated_params = result.output
      else
        head :bad_request
      end
    end

    def params_schema_registered?
      self.class.params_schemas.key?(params_schema_name)
    end

    def params_schema
      self.class.fetch_params_schema(params_schema_name)
    end

    def params_schema_name
      action_name.to_sym
    end
  end
end
