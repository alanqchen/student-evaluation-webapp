Rails.application.routes.draw do
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
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/dashboard', to: 'dashboards#index'
  get '/dashboard/settings', to: 'dashboards#edit'
  get '/dashboard/settings_turbo', to: 'dashboards#edit_dashboard'
  get '/dashboard/manage_users', to: 'dashboards#manage_users'
  get '/dashboard/manage_requests', to: 'dashboards#manage_requests'
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
  resources :courses
  resources :projects
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
