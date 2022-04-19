Rails.application.routes.draw do
  root 'static_pages#home'
  get 'sessions/new'
  get 'static_pages/home'
  get 'users/new'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/dashboard', to: 'dashboards#index'
  get '/dashboard/settings', to: 'dashboards#edit'
  resource :dashboard do
    get :settings, to: 'dashboards#edit'
  end
  scope(path_names: {}) do
    resources :dashboards, path: 'dashboard'
  end
  resources :users
  resources :courses
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
