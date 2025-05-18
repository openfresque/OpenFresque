OpenFresk::Engine.routes.draw do
  namespace :admin do
    resources :users
    resources :training_sessions
    
    resources :smtp_settings, only: [:index, :show, :edit, :update], 
                                controller: "open_fresk/admin/smtp_settings", 
                                as: :open_fresk_smtp_settings

    root to: "users#index", controller: "open_fresk/admin/users"
  end

  root to: "sessions#new"

  resources :sessions, only: %i[new create]
  resource  :recover_password, only: %i[new create]
  resource  :forgot_password, only: %i[new create]

  resources :training_sessions, only: %i[index] do
  end
end
