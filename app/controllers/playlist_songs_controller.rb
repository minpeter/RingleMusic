class PlaylistSongsController < ApplicationController

  def show
    @current_user = current_user
    if @current_user.nil?
      redirect_to '/login', alert: "로그인이 필요합니다."
      return
    end

    # playlistSong에 playlists_id로 조회해서 playlistSong의 song_id를 song에서 조회
    @playlist_song = PlaylistSong.where(playlist_id: params[:playlist_id])
    

    @playlist_name = Playlist.find(params[:playlist_id]).name

    # ======
    search_term = params[:search]
    sort_order = params[:sort]

    if search_term.present?
      @songs = Song.where("name LIKE ? OR artist LIKE ? OR album LIKE ?", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
    else
      @songs = Song.all
    end

    case sort_order
    when "relevance"
      @songs = @songs.order(Arel.sql("CASE WHEN name LIKE '#{search_term}%' THEN 1 WHEN name LIKE '%#{search_term}%' THEN 2 ELSE 3 END, likes DESC, created_at DESC"))
    when "popularity"
      @songs = @songs.order(likes: :desc)
    when "newest"
      @songs = @songs.order(created_at: :desc)
    else
      @songs = @songs.order(created_at: :desc)
    end
    @pl_songs = Song.where(id: @playlist_song.pluck(:song_id))
    @current_user = current_user
    # ======
  end

  def create
    song_id = params[:song_id]
    playlist_id = params[:playlist_id]
    added_by = current_user.id

    @playlist_song = PlaylistSong.new
    @playlist_song.song_id = song_id
    @playlist_song.playlist_id = playlist_id
    @playlist_song.added_by = added_by

    if @playlist_song.save
      redirect_to "/playlists/#{playlist_id}/playlist_songs", notice: "플레이리스트에 곡이 추가되었습니다."
    else
      redirect_to "/playlists/#{playlist_id}/playlist_songs", alert: "오류 발생!"
    end

  end

  def destroy

    song_id = params[:song_id]
    playlist_id = params[:playlist_id]

    @playlist_song = PlaylistSong.find_by(song_id: song_id, playlist_id: playlist_id)
    if @playlist_song.nil?
      redirect_to "/playlists/#{playlist_id}", notice: "오류 발생!"
      return
    end
    @playlist_song.destroy
    redirect_to "/playlists/#{playlist_id}", notice: "플레이리스트에서 곡이 삭제되었습니다."
  end
end
