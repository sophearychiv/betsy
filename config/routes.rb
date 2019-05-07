Rails.application.routes.draw do
  get "categories/new"
  get "categories/create"
  root "homepages#root"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :orderitems, only: [:edit, :update, :destroy]

  resources :products, except: [:destroy] do
    resources :reviews, only: [:new, :create]
    resources :orderitems, only: [:create]
  end

  patch "/products/:id/retire", to: "products#retire", as: "retire"
  get "/products/merchant/:id", to: "products#by_merch", as: "merch"
  get "/products/category/:id", to: "products#by_cat", as: "cat"

  get "/orders/confirmation", to: "orders#confirmation", as: "confirmation"
  resources :orders
  get "/empty_cart", to: "orders#empty_cart", as: "empty_cart"
  # post "/orders/checkout", to: "orders#checkout"
  resources :sessions, only: [:new, :create]
  resources :merchants, except: [:new, :create]
  resources :categories, only: [:index, :new, :create]
  get "/merchants/:id/dashboard", to: "merchants#dashboard", as: "dashboard"

  # get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"

  # delete request not working so changed to get. Thanks Dan!
  get "/logout", to: "sessions#destroy", as: "logout"
end
