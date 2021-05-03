class TrackController < ApplicationController

  def new
  	album_id = params[:album_id]
    track_name = params[:name]
    track_duration = params[:genre]
    times_played = 0
    track_duration = track_duration.to_f


    string =  track_name + ":" + album_id
    track_id = Base64.encode64(string).delete!("\n")
    if track_id.length > 22
      track_id = Base64.encode64(string).delete!("\n")[0,22]
    end 

    album = Album.find_by(album_id: album_id)
  	aid = album.artist_id
  	artist_id = Artist.find_by(id: aid).artist_id

    nombre_app = "localhost:3000"
    artist_url = nombre_app + "/artists/" + artist_id
    self_url = nombre_app + "/tracks/" + track_id
    album_url = nombre_app + "/albums/" + album_id
    track_params = params.permit(:name, :duration, :album_id)
  	track = Track.create(track_id: track_id, name: track_name, duration: track_duration, times_played: times_played,
  		artist_url: artist_url, album_url: album_url, self_url: self_url, artist_id: aid, album_id: album.id)

    if track.save
      render json: {id: track.track_id,
      	name: track.name, 
		duration: track.duration,
		times_played: times_played,
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
  	track = Track.find_by(track_id: track_id)
  	render json: {id: track.track_id,
  		name: track.name, 
		duration: track.duration,
		times_played: track.times_played,
		artist: track.artist_url,
		album: track.album_url,
		self: track.self_url},status: :ok
  end

  def play
  	track_id = params[:t_id]
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
  end

  def delete
  	track_id = params[:t_id]
  	track = Track.find_by(track_id: track_id)
  	track.destroy
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
