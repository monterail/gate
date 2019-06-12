# frozen_string_literal: true

class ValidController < ApplicationController
  before_action :verify_contract, if: lambda { |c|
    c.contract_registered? || c.action_name == "with_error"
  }

  contract do
    params do
      required(:foo).filled
      optional(:bar).maybe(:string)
    end
  end

  def with_validation
    render plain: claimed_params.inspect
  end

  contract(ValidWithClassValidationContract)

  def with_class_validation
    render plain: claimed_params.inspect
  end

  def without_validation
    head :ok
  end

  def with_error
    head :ok
  end
end
