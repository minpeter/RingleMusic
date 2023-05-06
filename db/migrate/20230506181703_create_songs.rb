class CreateSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs do |t|
      t.string :name
      t.integer :likes
      t.string :artist
      t.string :album

      t.timestamps
    end
  end
end
