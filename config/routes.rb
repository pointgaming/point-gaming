Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }

  resources :streams

  get "dashboard" => "dashboard#index"
  root "dashboard#index"
end
