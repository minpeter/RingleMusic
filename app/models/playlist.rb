class Playlist < ApplicationRecord
  belongs_to :user
  has_one :playlist_song, dependent: :destroy
  has_many :songs, through: :playlist_song
end
