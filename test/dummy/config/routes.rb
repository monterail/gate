# frozen_string_literal: true

Rails.application.routes.draw do
  get :foo, to: "application#foo"
end
