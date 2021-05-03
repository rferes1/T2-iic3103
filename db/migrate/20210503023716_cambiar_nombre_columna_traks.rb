class CambiarNombreColumnaTraks < ActiveRecord::Migration[5.2]
  def change
  	rename_column :tracks, :times_payed, :times_played
  end
end
