Rails.application.routes.draw do
  root 'home#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  
  get '/home', to: 'home#index'
end
