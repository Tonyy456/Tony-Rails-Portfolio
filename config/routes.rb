Rails.application.routes.draw do
  # CRUD = Create Read Update Destroy

  # models/user.rb
  devise_for :users, :skip => [:registrations], controllers: {
    sessions: 'users/sessions',
  }
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  # models/run.rb CRUD
  get '/runs', to: 'runs#index', as: 'runs'
  post '/runs', to: 'runs#create'
  get '/runs/new', to: 'runs#new', as: 'new_run'
  post '/runs/parse_csv', to: 'runs#parse_csv' #need be before /runs/:id else error. find this rule first
  get '/runs/upload_csv', to: 'runs#upload_csv'
  get '/runs/:id/edit', to: 'runs#edit', as: 'edit_run'
  get '/runs/:id', to: 'runs#show', as: 'run'
  patch '/runs/:id', to: 'runs#update'
  put '/runs/:id', to: 'runs#update'
  delete '/runs/:id', to: 'runs#destroy'

  # models/home_video.rb CRUD
  get '/home_videos', to: 'home_videos#index', as: 'home_videos'
  post '/home_videos', to: 'home_videos#create'
  get '/home_videos/new', to: 'home_videos#new', as: 'new_home_video'
  delete '/home_videos/:id', to: 'home_videos#destroy', as: 'home_video'

  # models/project.rb CRUD
  get '/projects', to: 'projects#index', as: 'projects'
  post '/projects', to: 'projects#create'
  get '/projects/new', to: 'projects#new', as: 'new_project'
  get '/projects/:id', to: 'projects#show', as: 'project'
  get '/projects/:id/edit', to: 'projects#edit', as: 'edit_project'
  patch '/projects/:id', to: 'projects#update'
  put '/projects/:id', to: 'projects#update'
  delete '/projects/:id', to: 'projects#destroy'
  
  # Runlog READ
  get 'runlog', to: 'runs#log' 
  get 'runlog/:year', to: 'runs#log'

  # Strava Controller does models/run.rb UPDATES
  get 'runlog/strava/recent', to: 'strava#recent' 
  get 'runlog/oauth', to: 'strava#oauth'     
  get 'runlog/callback', to: 'strava#callback' 

  # Need updated/removed
  get 'fileupload', to: 'home#fileupload'
  post 'upload', to: 'home#upload'
  get 'pin_test', to: 'pins#index'
  get 'admin', to: 'home#admin'
  get 'portfolio', to: 'portfolio#index'
  get 'home', to: 'home#index'
  
  root to: 'home#index'
  get 'ad', to: redirect('/users/sign_in')
end
