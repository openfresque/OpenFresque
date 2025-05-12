Rails.application.routes.draw do
  root to: "training_sessions#index"

  mount OpenFresk::Engine => "/"
end
