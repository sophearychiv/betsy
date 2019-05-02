Rails.application.routes.draw do
  root "homepages#root"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products, except: [:destroy]
  patch "/products/:id/retire", to: "products#retire", as: "retire"
  
  resources :orders, only: [:new, :create]
  # get "/orders/checkout", to: "orders#new"
  # post "/orders/checkout", to: "orders#checkout"
end
