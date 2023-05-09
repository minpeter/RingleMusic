
PlSong = Struct.new(:id, :name, :artist, :album, :added_by)


class PlaylistSongsController < ApplicationController

  def show
    @current_user = current_user
    if @current_user.nil?
      redirect_to '/login', alert: "로그인이 필요합니다."
      return
    end

    playlist_song = PlaylistSong.where(playlist_id: params[:playlist_id])
    @playlist_name = Playlist.find(params[:playlist_id]).name
    # 반복문으로 playlist_song의 song_id를 이용해 Song 테이블에서 곡 정보를 가져온다.

    @pl_songs = []
    playlist_song.reverse_each do |ps|
      song =  Song.find(ps.song_id)
      @pl_songs << PlSong.new(song.id, song.name, song.artist, song.album, ps.added_by)
    end

    puts @pl_songs
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
    
    @current_user = current_user
    # ======
  end

  def create
    song_id = params[:song_id]
    playlist_id = params[:playlist_id]

    @playlist_song = PlaylistSong.new
    @playlist_song.song_id = song_id
    @playlist_song.playlist_id = playlist_id
    @playlist_song.added_by = current_user.name

    # 100개 이상의 곡을 추가할 수 없도록 한다. 넘어가는 경우 가장 처음 추가된 항목 삭제
    if PlaylistSong.where(playlist_id: playlist_id).count >= 5
      @playlist_song_delete = PlaylistSong.where(playlist_id: playlist_id).first
      @playlist_song_delete.destroy
    end
    if @playlist_song.save
      redirect_to "/playlists/#{playlist_id}", notice: "플레이리스트에 곡이 추가되었습니다."
    else
      redirect_to "/playlists/#{playlist_id}", alert: "오류 발생!"
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
