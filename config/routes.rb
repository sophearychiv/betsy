Rails.application.routes.draw do
  root "homepages#root"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :orders, only: [:new, :create]
end
