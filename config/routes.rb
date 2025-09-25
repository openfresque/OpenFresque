OpenFresk::Engine.routes.draw do
  root to: 'sessions#new'

  resources :sessions, only: %i[new create]
  resource  :recover_password, only: %i[new create]
  resource  :forgot_password, only: %i[new create]

  resources :training_sessions do
    member do
      get :product_configurations
      post :set_product_configurations
      get :show_public
    end

    collection do
      get :public
    end

    resources :public_participations, only: %i[create] do
      collection do
        get :ticket_choice
        get :personal_informations
        post :personal_informations
        patch :update
      end
    end
  end

  resources :session_participations, only: %i[show]

  namespace :api do
    resources :users
  end
end
