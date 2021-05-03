class CambiarNombreColumnasArtist < ActiveRecord::Migration[5.2]
  def change
  	rename_column :artists, :albums, :albums_url
  	rename_column :artists, :tracks, :tracks_url
  end
end


