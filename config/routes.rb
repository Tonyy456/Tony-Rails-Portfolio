Rails.application.routes.draw do
  resources :pins
  devise_for :users, :skip => [:registrations], controllers: {
    sessions: 'users/sessions',
  }
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  
  get 'portfolio', to: 'portfolio#index'
  get 'home', to: 'home#index'
  get 'pin_test', to: 'pins#index'
  get 'ad', to: redirect('/users/sign_in')

  root to: 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
