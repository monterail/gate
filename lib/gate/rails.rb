# frozen_string_literal: true

module Gate
  module Rails
    attr_reader :validated_params

    SchemaNotDefined = Class.new(StandardError)
    @base_schema = nil

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    def self.configure(&block)
      @base_schema = Class.new(Dry::Validation::Schema, &block)
    end

    module ClassMethods
      def params_schemas
        @params_schemas ||= {}
      end

      def fetch_params_schema(schema_name)
        params_schemas.fetch(schema_name) do
          raise SchemaNotDefined, "Missing `#{schema_name}` schema"
        end
      end

      def def_schema(&block)
        @_schema = Dry::Validation.Params(Gate::Rails::instance_variable_get(:@base_schema), &block)
      end

      def method_added(method_name)
        return unless instance_variable_defined?(:@_schema)

        params_schemas[method_name] = @_schema
        remove_instance_variable(:@_schema)
      end
    end

    def validate_params
      result = params_schema.call(request.params)

      if result.success?
        @validated_params = result.output
      else
        handle_invalid_params(result.messages)
      end
    end

    def handle_invalid_params(_errors)
      head :bad_request
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
