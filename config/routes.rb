Rails.application.routes.draw do

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: "pages#dashboard", as: :authenticated_root
      get '/users', to: 'devise/registrations#edit'
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
      get '/users', to: 'devise/registrations#new'
    end

    get '/users/password', to: 'devise/passwords#new'
  end

  root :to => "devise/sessions#new"
end
