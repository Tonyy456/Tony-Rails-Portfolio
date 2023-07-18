Rails.application.routes.draw do
  resources :runs do
    collection do
      post :parse_csv
      get :upload_csv
    end
  end
  resources :home_videos, :except => [:edit, :show, :update]
  resources :pins
  devise_for :users, :skip => [:registrations], controllers: {
    sessions: 'users/sessions',
  }
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  
  get 'fileupload', to: 'home#fileupload'
  post 'upload', to: 'home#upload'

  get 'admin', to: 'home#admin'
  get 'portfolio', to: 'portfolio#index'
  get 'home', to: 'home#index'
  get 'pin_test', to: 'pins#index'
  get 'ad', to: redirect('/users/sign_in')

  get 'runlog', to: 'strava#index'                 # Tony's Runlog and runstreak tracker
  get 'runlog/:year', to: 'strava#index'
  get 'runlog/strava/recent', to: 'strava#recent' # most recent 100 runs. Must go through runlog/oauth
  get 'runlog/oauth', to: 'strava#oauth'        # Redirects you to strava
  get 'runlog/callback', to: 'strava#callback' # redirected to after runlog/oauth

  root to: 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
