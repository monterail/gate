# frozen_string_literal: true

class InvalidController < ApplicationController
  before_action :validate_params, if: lambda { |c|
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

  def handle_invalid_params(errors)
    render plain: errors.inspect, status: :bad_request
  end
end
