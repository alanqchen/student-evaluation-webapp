Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home'
  get 'users/new'
  get '/signup', to: 'users#new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
