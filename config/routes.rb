OpenFresk::Engine.routes.draw do
  root to: "sessions#new"

  resources :sessions, only: %i[new create]
  resource  :recover_password, only: %i[new create]
  resource  :forgot_password, only: %i[new create]

  resources :training_sessions, only: %i[index] do
  end
end
