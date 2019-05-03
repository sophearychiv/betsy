Rails.application.routes.draw do
  get 'reviews/new'
  get 'reviews/create'
  root "homepages#root"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :orderitems, except: [:index, :new, :show]
  resources :products, except: [:destroy]
  patch "/products/:id/retire", to: "products#retire", as: "retire"

  resources :orders, only: [:new, :create]
  # get "/orders/checkout", to: "orders#new"
  # post "/orders/checkout", to: "orders#checkout"
end
