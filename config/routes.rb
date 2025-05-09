# frozen_string_literal: true

Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Registry ---
  scope defaults: { format: 'json' }, controller: :packages,
        constraints: { subdomain: 'registry' } do
    get '', action: :index
    get '*package', action: :show, package: /.+/
  end

  # UI ---
  get 'ui' => 'ui#index'
  namespace :ui do
    get :breadcrumbs, to: 'breadcrumbs#index'

    get :form, to: 'form#index'
    namespace :form do
      get 'text_field'
      get 'file_field'
      get 'url_field'
      get 'email_field'
      get 'number_field'
      get 'time_field'
      get 'date_field'
      get 'datetime_local_field'
      get 'week_field'
      get 'month_field'
      get 'color_field'
      get 'search_field'
      get 'password_field'
      get 'range_field'
      get 'tel_field'
      get 'checkbox_field'
      get 'select_field'
      get 'radio_group'
      get 'radio_field'
      get 'textarea_field'
      get 'rich_textarea_field'
      get 'hidden_field'
    end

    get :ujs, to: 'ujs#index'
    namespace :ujs do
      get 'disable_with'
      get 'confirm'
    end
  end

  root to: 'pages#index'
end
