class TrackController < ApplicationController

  def new
  	album_id = params[:album_id]
    track_name = params[:name]
    track_duration = params[:genre]
    times_played = 0
    track_duration = track_duration.to_f

    if track_duration == "" or track_name == ""
      return render status: :bad_request
    end


    string =  track_name + ":" + album_id
    track_id = Base64.encode64(string).delete!("\n")
    if track_id.length > 22
      track_id = Base64.encode64(string).delete!("\n")[0,22]
    end 


	
	if Album.exists?(album_id: params[:album_id])
    	album = Album.find_by(album_id: album_id)
	  	aid = album.artist_id

	  	if Artist.exists?(aid)
	  		artist_id = Artist.find_by(id: aid).artist_id

	  		if Track.exists?(track_id: track_id)
				track = Track.find_by(track_id: track_id)
				sts = :conflict
			else
			    nombre_app = "https://t2-iic3103-rferes.herokuapp.com"
			    artist_url = nombre_app + "/artists/" + artist_id
			    self_url = nombre_app + "/tracks/" + track_id
			    album_url = nombre_app + "/albums/" + album_id

			    track_params = params.permit(:name, :duration, :album_id)
			  	track = Track.create(track_id: track_id, name: track_name, duration: track_duration, times_played: times_played,
			  		artist_url: artist_url, album_url: album_url, self_url: self_url, artist_id: aid, album_id: album.id)

			    if track.save
			      sts = :created
			    else
			      sts = :unprocessable_entity
			    end
			end
			render json: {id: track.track_id,
			      	name: track.name, 
					duration: track.duration,
					times_played: times_played,
					artist: track.artist_url,
					album: track.album_url,
					self: track.self_url},status: sts
		else
	  		render status: :not_found
	  	end
	else
		render status: :not_found
	end
  end
  def index
  	tracks = Track.order('created_at DESC');
    tracks_json = []
    tracks.each do |track|
      json = {id: track.track_id, name: track.name, duration: track.duration, times_played: track.times_played, artist: track.artist_url,
      album: track.album_url, self: track.self_url}
      tracks_json.push(json)
    end
    render json: tracks_json,status: :ok
  end

  def show
  	track_id = params[:t_id]
  	if Track.exists?(track_id: track_id)
	  	track = Track.find_by(track_id: track_id)
	  	render json: {id: track.track_id,
	  		name: track.name, 
			duration: track.duration,
			times_played: track.times_played,
			artist: track.artist_url,
			album: track.album_url,
			self: track.self_url},status: :ok
	else 
		render status: :not_found
	end
  end

  def play
  	track_id = params[:t_id]
  	if Track.exists?(track_id: track_id)
	  	track = Track.find_by(track_id: track_id)
	  	tp = track.times_played
	  	ntp = tp + 1

	  	if track.update_attribute(:times_played, ntp)
	      render json: {id: track.track_id,
	  		name: track.name, 
			duration: track.duration,
			times_played: track.times_played,
			artist: track.artist_url,
			album: track.album_url,
			self: track.self_url},status: :ok
	    else
	      render json: {id: track.track_id,
	      	name: track.name, 
			duration: track.duration,
			times_played: times_played,
			artist: track.artist_url,
			album: track.album_url,
			self: track.self_url},status: :unprocessable_entity
	    end
	else
		render status: :not_found
	end
  end

  def delete
  	track_id = params[:t_id]
  	if Track.exists?(track_id: track_id)
	  	track = Track.find_by(track_id: track_id)
	  	track.destroy
	  	render status: :no_content
	else
		render status: :not_found
	end
  end
end

=begin
ENTRA
{
  "name": "Don't Stop 'Til You Get Enough",
  "duration": 4.1
}

RETORNA

{
  "id": "RG9uJ3QgU3RvcCAnVGlsIF",
  "album_id": "T2ZmIHRoZSBXYWxsOlRXbG",
  "name": "Don't Stop 'Til You Get Enough",
  "duration": 4.1,
  "times_played": 0,
  "artist": "https://apihost.com/artists/TWljaGFlbCBKYWNrc29u",
  "album": "https://apihost.com/albums/T2ZmIHRoZSBXYWxsOlRXbG",
  "self": "https://apihost.com/tracks/RG9uJ3QgU3RvcCAnVGlsIF"
}

=end
