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

  # tags controller
  get '/tags', to: 'tags#index', as: 'tag_manager'
  get '/tags/show/:id', to: 'tags#show', as: 'tag_show'
  get '/tags/edit/:id', to: 'tags#edit', as: 'tag_edit'
  post '/tags/edit/:id', to: 'tags#update', as: 'tag_update'
  delete '/tags/destroy/:id', to: 'tags#destroy', as: 'tag_destroy'

  # models/run.rb CRUD
  get '/runs/manager', to: 'runs#manager', as: 'runs_manager'
  get '/runs/calendar/:year/:month', to: 'runs#calendar', as: 'runs_calendar'
  get '/runs/condensed', to: 'runs#condensed_view', as:'runs_condensed'
  get '/runs', to: 'runs#index', as: 'runs'
  get '/runs/refresh/login', to: 'strava#index', as: 'strava_login'

  get '/runs/new', to: 'runs#new', as: 'new_run'
  post '/runs/new', to: 'runs#create', as: 'new_run_post'

  post '/runs/parse_csv', to: 'runs#parse_csv'
  get '/runs/upload_csv', to: 'runs#upload_csv'
  get 'runs/multi_delete', to: 'runs#multi_delete', as: 'multi_delete'
  delete 'runs/multi_delete', to: 'runs#destroy_multiple', as: 'delete_multiple_runs'

  get '/runs/:id/edit', to: 'runs#edit', as: 'edit_run'
  patch '/runs/:id/edit', to: 'runs#update', as: 'edit_run_patch'
  get '/runs/:id', to: 'runs#show', as: 'run'
  delete '/runs/:id', to: 'runs#destroy', as: 'delete_run'

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
  
  # Strava Controller does models/run.rb UPDATES
  get 'runlog/strava/recent', to: 'strava#recent' , as: 'strava_recent'
  get 'runlog/oauth', to: 'strava#oauth', as: 'strava_oauth'
  get 'runlog/callback', to: 'strava#callback'
  
  # Runlog READ
  get 'runlog', to: 'runs#log'
  get 'runlog/:year', to: 'runs#log'

  # Need updated/removed
  get 'fileupload', to: 'home#fileupload'
  post 'upload', to: 'home#upload'
  get 'pin_test', to: 'pins#index'
  get 'admin', to: 'home#admin'
  get 'portfolio', to: 'portfolio#index'
  get 'home', to: 'home#index'

  # TODO get rid of this?
  get 'autologger', to: 'strava#auto_logger', as: 'autologger'

  patch 'toggle_tag_hide_in_view/:id', to: 'tags#toggle_tag_hide_in_view', as: 'toggle_tag_hide'
  patch 'toggle_tag_on_project/:id', to: 'projects#toggle_tag_on_project', as: 'toggle_tag_on_project'
  patch 'hide_on_all_projects/:id', to: 'tags#hide_on_all_projects', as: 'hide_on_all_projects'
  patch 'show_on_all_projects/:id', to: 'tags#show_on_all_projects', as: 'show_on_all_projects'
  patch 'toggle_relevance_on_project/:id', to: 'projects#toggle_relevance', as: 'toggle_relevance_on_project'

  get 'resume', to: 'home#resume', as: 'resume'
  get 'show_file/:filename', to: 'home#show_file', as: 'show_file'
  
  root to: 'home#index'
  get 'ad', to: redirect('/users/sign_in')
end
