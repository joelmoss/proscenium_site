# frozen_string_literal: true

Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Registry ---
  scope constraints: { subdomain: 'registry' } do
    get 'tarballs/:name/:version', to: 'tarballs#show',
                                   constraints: { name: /[\w\-_]+/, version: /[\w\-._]+\.tgz/ }

    scope defaults: { format: 'json' }, controller: :packages do
      get '', action: :index
      get '*package', action: :show, package: /.+/
    end
  end

  root to: 'pages#index'
end
