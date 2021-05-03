class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :album_id
      t.string :name
      t.string :genre
      t.string :artist_url
      t.string :tracks_url
      t.string :self_url
      t.references :artist, foreign_key: true

      t.timestamps
    end
  end
end
