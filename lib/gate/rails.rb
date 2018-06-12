# frozen_string_literal: true

require "pry"

module Gate
  module Rails
    SchemaNotDefined = Class.new(StandardError)

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      attr_reader :schemas

      def def_validation(name, &block)
        @schemas ||= {}
        @schemas[name] = Dry::Validation.Params(&block)
      end
    end

    def validate_action
      result = action_params_schema.call(request.params)

      return if result.success?

      head :bad_request
    end

    def action_params_schema
      self.class.schemas.fetch(action_name.to_sym) do
        raise SchemaNotDefined, action_name
      end
    end
  end
end
