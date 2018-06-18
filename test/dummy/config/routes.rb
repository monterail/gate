# frozen_string_literal: true

Rails.application.routes.draw do
  get :with_validation, to: "valid#with_validation"
  get :without_validation, to: "valid#without_validation"
  get :with_error, to: "valid#with_error"

  get :with_custom_invalid, to: "invalid#with_custom_invalid"
end
