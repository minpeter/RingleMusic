Rails.application.routes.draw do
  root 'songs#index'

  get '/songs', to: 'songs#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/playlist/new', to: 'playlists#new'

  resources :playlists, only: [:index, :create, :destroy] do
    get '/', to: 'playlist_songs#show'
    post '/song', to: 'playlist_songs#create', as: 'song_create'
    delete  '/song', to: 'playlist_songs#destroy', as: 'song_destroy'
  end

end
