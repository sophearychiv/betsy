Rails.application.routes.draw do
  root "homepages#root"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :orderitems, except: [:index, :new, :show]
  resources :products, except: [:destroy]
  patch "/products/:id/retire", to: "products#retire", as: "retire"
  get "/products/merchant/:id", to: "products#by_merch", as:"merch"

  resources :orders, only: [:new, :create]
  get "/orders/confirmation", as: "confirmation"
  # post "/orders/checkout", to: "orders#checkout"
end
