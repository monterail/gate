# frozen_string_literal: true

module Gate
  module Rails
    attr_reader :validated_contracts

    ContractNotDefined = Class.new(StandardError)

    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def _contracts
        @_contracts ||= {}
      end

      def contract_for(contract_name)
        _contracts.fetch(contract_name) do
          raise ContractNotDefined, "Missing `#{contract_name}` contract"
        end
      end

      def contract(&block)
        @_contract = Dry::Validation.Contract(&block)
      end

      def method_added(method_name)
        return unless instance_variable_defined?(:@_contract)

        _contracts[method_name] = @_contract
        remove_instance_variable(:@_contract)
      end
    end

    def validate_params
      result = self.class.contract_for(_contract_name).call(request.params)

      if result.success?
        @validated_params = result.output
      else
        handle_invalid_params(result.messages)
      end
    end

    def handle_invalid_params(_errors)
      head :bad_request
    end

    def contract_registered?
      self.class._contracts.key?(_schema_name)
    end

    def _contract_name
      action_name.to_sym
    end
  end
end
