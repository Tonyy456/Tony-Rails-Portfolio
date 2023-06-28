Rails.application.routes.draw do
  get 'portfolio', to: 'portfolio#index'
  get 'home', to: 'home#index'
  root to: 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
