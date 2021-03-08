# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs" unless Rails.env.production?
  mount Rswag::Api::Engine => "/api-docs" unless Rails.env.production?

  namespace :api do
    namespace :v1 do
      post "in_stocks", to: "stocks#in_stocks"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
