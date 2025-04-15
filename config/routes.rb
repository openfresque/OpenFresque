OpenFresk::Engine.routes.draw do
  resources :sessions, only: %i[new create]
  resource  :forgot_password, only: %i[new create]
end
