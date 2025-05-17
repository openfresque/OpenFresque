OpenFresk::Engine.routes.draw do
  namespace :admin do
    # Add dashboard for each model wanted in Admin
    # resources :users
    # resources :training_sessions

    root to: "users#index" # Adjust if users is not the default dashboard
  end

  root to: "sessions#new"

  resources :sessions, only: %i[new create]
  resource  :recover_password, only: %i[new create]
  resource  :forgot_password, only: %i[new create]

  resources :training_sessions, only: %i[index] do
  end
end
