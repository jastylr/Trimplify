Trimplify::Application.routes.draw do
  
  root :to => 'welcome#index'
  post "/" => "users#create", as: :users
  get "login" => "sessions#new"
  post "sessions/create"
  get "logout" => "sessions#destroy", as: :logout

  # to preserve original prefix
  resources :users, except: [:create]
  resources :user_vitals, only: [:new, :create, :edit, :update]
  resources :weight_stats, only: [:new, :create]
  
end
