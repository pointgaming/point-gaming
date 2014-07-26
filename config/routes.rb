Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }

  resources :streams do
    resources :collaborators, only: [:index, :create, :destroy]
    resources :matches,       only: [:index, :create, :update, :destroy]
    resources :bets,          only: [:index, :create, :update]

    collection { get "validate_name" }
  end

  get "users/search" => "users#search"
  get "socket" => "socket#index"


  get "profile" => "profile#edit"
  get "profile/settings" => "profile#settings"

  resources :users

  root "streams#index"
end
