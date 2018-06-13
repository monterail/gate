# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Gate::Rails

  before_action :validate_params, if: lambda { |c|
    c.params_schema_registered? || c.action_name == "with_error"
  }

  def_schema do
    required(:foo).filled
    optional(:bar).maybe
  end

  def with_validation
    head :ok
  end

  def without_validation
    head :ok
  end

  def with_error
    head :ok
  end
end
