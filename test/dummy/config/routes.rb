# frozen_string_literal: true

Rails.application.routes.draw do
  get :with_validation, to: "application#with_validation"
  get :without_validation, to: "application#without_validation"
  get :with_error, to: "application#with_error"
end
