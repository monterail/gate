# frozen_string_literal: true

class InvalidController < ApplicationController
  before_action :validate_params, if: lambda { |c|
    c.params_schema_registered?
  }

  def_schema do
    required(:foo).filled(:foo?)
  end

  def with_custom_invalid
    head :ok
  end

  def handle_invalid_params(errors)
    render plain: errors.inspect, status: :bad_request
  end
end
