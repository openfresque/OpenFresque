Rails.application.routes.draw do
  namespace :admin do
      resources :training_sessions
      resources :users

      root to: "training_sessions#index"
    end
  root to: "training_sessions#index"

  mount OpenFresk::Engine => "/"
end
