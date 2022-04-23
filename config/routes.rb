Rails.application.routes.draw do
  get 'teams/new'
  get 'teams/edit'
  get 'teams/show'
  get 'teams/destroy'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'evaluations/new'
  get 'evaluations/edit'
  get 'evaluations/submit'
  get 'evaluations/unsubmit'
  get 'evaluations/show'
  root 'static_pages#home'
  get 'sessions/new'
  get 'static_pages/home'
  get 'users/new'
  get 'users/:id/edit', to: 'users#show_edit_user'
  post 'users/:id/edit', to: 'users#edit_user'
  post 'user/edit', to: 'users#edit'
  delete '/users/:id', to: 'users#destroy'
  get '/user/:uid/teams', to: 'teams#show_users_teams'
  get '/user/:uid/team/:tid', to: 'teams#show_user_team'
  delete '/teams/:id', to: 'teams#destroy'
  post '/teams', to: 'teams#create'
  post '/teams/:id/edit', to: 'teams#edit_team'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/dashboard', to: 'dashboards#index'
  get '/dashboard/settings', to: 'dashboards#edit'
  get '/dashboard/settings_turbo', to: 'dashboards#edit_dashboard'
  get '/dashboard/manage_users', to: 'dashboards#manage_users'
  get '/dashboard/manage_requests', to: 'dashboards#manage_requests'
  get '/dashboard/courses', to: 'courses#index', as: 'courses'
  get '/dashboard/course/new', to: 'courses#new', as: 'new_course'
  post '/dashboard/course/new', to: 'courses#create', as: 'create_course'
  get '/dashboard/course/:id', to: 'courses#show', as: 'course'
  get '/dashboard/course/:id/edit', to: 'courses#edit', as: 'edit_course'
  post '/dashboard/course/:id/edit', to: 'courses#update', as: 'update_course'
  delete '/dashboard/courses/:id/delete', to: 'courses#destroy', as: 'destroy_course'
  get '/dashboard/course/:id/user/new', to: 'courses#new_user', as: 'new_course_user'
  post '/dashboard/course/:id/user/new', to: 'courses#create_and_add_user', as: 'create_and_add_course_user'
  get '/dashboard/course/:id/user/:uid/edit', to: 'courses#edit_course_user', as: 'edit_course_user'
  post '/dashboard/course/:id/user/:uid/edit', to: 'courses#update_course_user', as: 'update_course_user'
  delete '/dashboard/course/:id/user/:uid', to: 'courses#destroy_course_user', as: 'destroy_course_user'
  get '/dashboard/course/:id/teams/new', to: 'teams#new', as: 'new_course_team'
  post '/dashboard/course/:id/teams/new', to: 'teams#create', as: 'create_course_team'
  get '/dashboard/course/:id/team/:id', to: 'team#show', as: 'show_course_team'
  get '/dashboard/course/:id/projects/new', to: 'projects#new', as: 'new_course_project'
  post '/dashboard/course/:id/projects/new', to: 'projects#create', as: 'create_course_project'
  get '/dashboard/course/:id/project/:pid', to: 'projects#show', as: 'show_course_project'
  get '/dashboard/course/:id/project/:pid/edit', to: 'projects#edit', as: 'edit_course_project'
  post '/dashboard/course/:id/project/:pid/edit', to: 'projects#update', as: 'update_course_project'
  delete '/dashboard/course/:id/project/:pid/delete', to: 'projects#destroy', as: 'destroy_course_project'
  get '/dashboard/evaluations', to: 'evaluations#index', as: 'evaluations'
  get '/dashboard/evaluation/:id', to: 'evaluations#show', as: 'show_evaluation'
  get '/dashboard/evaluation/:id/edit', to: 'evaluation#edit', as: 'edit_evaluation'
  post '/dashboard/evaluation/:id/edit', to: 'evaluation#update', as: 'update_evaluation'
  delete '/dashboard/evaluation/:id/delete', to: 'evaluation#destroy', as: 'destroy_evaluation'
  resources :account_activations, only: [:edit]
  post '/requests/:id', to: 'requests#accept'
  delete '/requests/:id', to: 'requests#reject'
  resources :requests, only: [:show, :new, :create]
  resource :dashboard do
    get :settings, to: 'dashboards#edit'
  end
  scope path_names: {} do
    resources :dashboards, path: 'dashboard'
  end
  resources :users

  resources :projects
  get 'projects/new'

  resources :teams

  resources :password_resets, only: [:new, :create, :edit, :update]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
