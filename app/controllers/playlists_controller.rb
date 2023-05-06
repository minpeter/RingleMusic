class PlaylistsController < ApplicationController
  
  def index
    @current_user = current_user

    @playlists = Playlist.where(user_id: @current_user.id)
  end

  def new
    @current_user = current_user
  end

  def create

    @current_user = current_user

    @playlist = Playlist.new
    @playlist.name = params[:name]
    @playlist.user_id = @current_user.id

    if @playlist.save
      redirect_to '/playlists', notice: "플레이리스트가 생성되었습니다."
    else
      redirect_to '/playlists/new', alert: "오류 발생!"
    end

  end
end
