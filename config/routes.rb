Trimplify::Application.routes.draw do
  
  root :to => 'welcome#index'
  post "/" => "users#create", as: :users
  # to preserve original prefix
  resources :users, except: [:create]
  # resources :users, :path => 'users/new'
  # get "users/new"
  # get "users/create"
  # get "welcome/index"
  
  
end
