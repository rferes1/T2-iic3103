class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.string :track_id
      t.string :name
      t.float :duration
      t.integer :times_payed
      t.string :artist_url
      t.string :album_url
      t.string :self_url
      t.references :artist, foreign_key: true
      t.references :album, foreign_key: true

      t.timestamps
    end
  end
end
