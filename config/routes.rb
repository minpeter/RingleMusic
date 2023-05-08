Rails.application.routes.draw do
  root 'songs#index'

  get '/songs', to: 'songs#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'


  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  # get '/playlists', to: 'playlists#index'
  # get '/playlists/new', to: 'playlists#new'
  # post '/playlists', to: 'playlists#create'
  # delete '/playlists/:id(.:format)', to: 'playlists#destroy'

  resources :playlists, only: [:index, :new, :create, :destroy]
  

end
