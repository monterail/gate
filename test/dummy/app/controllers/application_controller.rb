# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Gate::Rails

  before_action :validate_action

  def_validation(:foo) do
    required(:foo).filled
    optional(:bar).maybe
  end

  def foo
    head :ok
  end
end
