class SongsController < ApplicationController
  def index
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
    # render json: @songs
  end
end
