# frozen_string_literal: true

class InvalidController < ApplicationController
  before_action :verify_contract, if: lambda { |c|
    c.contract_registered?
  }

  contract do
    params do
      required(:foo).filled(:string)
    end
  end

  def with_custom_invalid
    head :ok
  end

  contract(handler: :custom_handler) do
    params do
      required(:foo).filled(:string)
    end
  end

  def with_custom_handler
    head :ok
  end

  def handle_invalid_params(errors)
    render plain: errors.inspect, status: :bad_request
  end

  def custom_handler(_errors)
    render plain: "handled", status: :bad_request
  end
end
