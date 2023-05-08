class PlaylistsController < ApplicationController
  
  def index
    @current_user = current_user
    if @current_user.nil?
      redirect_to '/login', alert: "로그인이 필요합니다."
      return
    end

    @playlists = Playlist.where(user_id: @current_user.id)
  end

  def new
    @current_user = current_user
  end

  def create

    @current_user = current_user

    if @current_user.nil?
      redirect_to '/login', alert: "로그인이 필요합니다."
      return
    end

    @playlist = Playlist.new
    @playlist.name = params[:name]
    @playlist.user_id = @current_user.id

    if @playlist.save
      redirect_to '/playlists', notice: "플레이리스트가 생성되었습니다."
    else
      redirect_to '/playlists/new', alert: "오류 발생!"
    end

  end

  def destroy
    # get id from playlists/:id
    id = params[:id]
    @playlist = Playlist.find(id)

    name = @playlist.name
    @playlist.destroy
    redirect_to '/playlists', notice: "#{name} 플레이리스트가 삭제되었습니다."
  end
end
