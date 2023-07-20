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
  
  # testing
  get 'fileupload', to: 'home#fileupload'
  post 'upload', to: 'home#upload'
  get 'pin_test', to: 'pins#index'
  
  # misc
  get 'admin', to: 'home#admin'
  get 'portfolio', to: 'portfolio#index'
  get 'home', to: 'home#index'
  
  # Runlog Reading
  get 'runlog', to: 'runs#log' 
  get 'runlog/:year', to: 'runs#log'
  
  # Strava Controller
  get 'runlog/strava/recent', to: 'strava#recent' 
  get 'runlog/oauth', to: 'strava#oauth'     
  get 'runlog/callback', to: 'strava#callback' 
  
  root to: 'home#index'
  get 'ad', to: redirect('/users/sign_in')
end
