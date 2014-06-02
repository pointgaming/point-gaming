Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }

  resources :streams do
    resources :collaborators, only: [:index, :create, :destroy]
    resources :matches,       only: [:index, :create, :destroy, :update]
    resources :bets,          only: [:index, :create, :destroy, :update]

    collection { get "validate_name" }
  end

  get "users/search" => "users#search"
  get "dashboard" => "dashboard#index"
  get "socket" => "socket#index"

  root "dashboard#index"
end
