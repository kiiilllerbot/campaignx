Rails.application.routes.draw do
  require 'sidekiq/web'

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Vonage SMS Delivery Receipt
  resources :sms_delivery_receipts, only: [:create]
  
  resources :campaigns, only: [:index, :new, :create, :show]
  resources :audiences
  get 'users/profile'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: "pages#dashboard", as: :authenticated_root
      get '/users', to: 'devise/registrations#edit'
      get '/profile', to: 'users#profile', as: :profile
      get '/transactions', to: 'pages#transactions', as: :transactions
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
      get '/users', to: 'devise/registrations#new'
    end

    get '/users/password', to: 'devise/passwords#new'
  end

  root :to => "devise/sessions#new"
end
