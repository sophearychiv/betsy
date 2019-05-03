Rails.application.routes.draw do
  root "homepages#root"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products, except: [:destroy]
  patch "/products/:id/retire", to: "products#retire", as: "retire"
  
  resources :orders, only: [:new, :create]
  resources :sessions, only: [:new, :create]
  resources :merchants, except: [:new, :create]


  get "/auth/github", as: "github_login"
  get '/auth/:provider/callback', to: "sessions#create", as: 'auth_callback'


  delete '/logout', to: 'sessions#destroy', as: 'logout'
end
