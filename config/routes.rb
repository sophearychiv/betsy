Rails.application.routes.draw do
  root "homepages#root"
  get "homepages/about", to: "homepages#about", as: "about"

  resources :orderitems, only: [:edit, :update, :destroy]

  resources :products, except: [:destroy] do
    resources :reviews, only: [:new, :create]
    resources :orderitems, only: [:create]
  end

  patch "/products/:id/retire", to: "products#retire", as: "retire"

  get "/orders/confirmation", to: "orders#confirmation", as: "confirmation"
  # get "/orders/:id/checkout", to: "orders#checkout", as: "checkout_order"

  # get "/orders/:id/cancel", to: "orders#cancel", as: "cancel_order"
  patch "/orders/:id/cancel", to: "orders#cancel", as: "cancel_order"
  # patch "/orders/:id/cancel", to: "orders#cancel"
  get "/orders/:id/review", to: "orders#review", as: "review_order"
  resources :orders
  get "/empty_cart", to: "orders#empty_cart", as: "empty_cart"
  # post "/orders/checkout", to: "orders#checkout"
  resources :sessions, only: [:new, :create]
  resources :merchants, except: [:new, :create]
  get "/merchants/:id/dashboard", to: "merchants#dashboard", as: "dashboard"

  resources :categories, only: [:index, :show, :new, :create]

  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"

  # delete request not working so changed to get. Thanks Dan!
  get "/logout", to: "sessions#destroy", as: "logout"
end
