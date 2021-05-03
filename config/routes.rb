Rails.application.routes.draw do

	## ----------- Artists --------------
	###### GET
	get 'artists', to: 'artist#index'
	get 'artists/:a_id', to: 'artist#show'
	get 'artists/:a_id/albums', to: 'artist#show_albums'
	get 'artists/:a_id/tracks', to: 'artist#show_tracks'
	###### POST
	post 'artists', to: 'artist#new'
	post 'artists/:a_id/albums', to: 'album#new'
	###### PUT
	put 'artists/:a_id/albums/play', to: 'artist#play_tracks'
	###### DELETE
	delete 'artists/:a_id', to: 'artist#delete'

	## ----------- ALBUMS --------------
	###### GET
	get 'albums', to: 'album#index'
	get 'albums/:album_id', to: 'album#show'
	get 'albums/:album_id/tracks', to: 'album#show_tracks'
	###### POST
	post 'albums/:album_id/tracks', to: 'track#new'
	###### PUT
	put '/albums/:album_id/tracks/play', to: 'album#play_tracks'
	###### DELETE
	 delete 'albums/:album_id', to: 'album#delete'

	## ----------- TRACKS --------------
	###### GET
	get 'tracks', to: 'track#index'
	get 'tracks/:t_id', to: 'track#show'
	###### PUT
	put 'tracks/:t_id/play', to: 'track#play'
	###### DELETE
	delete 'tracks/:t_id', to: 'track#delete' 

end


