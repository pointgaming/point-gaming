Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }

  resources :streams do
    resources :collaborators, only: [:index, :create, :destroy]
    resources :matches,       only: [:index, :create, :destroy, :update]

    collection { get "validate_name" }
  end

  get "users/search" => "users#search"

  get "dashboard" => "dashboard#index"
  get "chat" => "chat#chat", as: "chat"
  root "dashboard#index"
end
