require "base64"
require 'json'


class ArtistController < ApplicationController

  def home
  end

  def unknown
    render status: :method_not_allowed
  end

  def new
    artist_name = params[:name]
    artist_age = params[:age]
    artist_age_int = artist_age.to_i
    artist_age_str = artist_age_int.to_s

    valido = true
    params.each do |key, value|
      #if (key != "name" or key != "age")
      #  valido = false
      #end
      #if  (key == "name" or key == "age") and value == ""
       # valido = false
      end
      if artist_age_str != params[:age]
        valido = false
      end
    end

    if !(valido)
      render status: :bad_request
    else
      artist_id = Base64.encode64(artist_name).delete!("\n")
      if artist_id.length > 22
        artist_id = Base64.encode64(artist_name).delete!("\n")[0,22]
      end 

      if Artist.exists?(artist_id: artist_id)
        artist = Artist.find_by(artist_id: artist_id)
        sts = :conflict
      else
        nombre_app = "https://t2-iic3103-rferes.herokuapp.com/"
        albums_url = nombre_app + "artists/" + artist_id + "/albums"
        tracks_url = nombre_app + "artists/" + artist_id + "/tracks"
        self_url = nombre_app + "artists/" + artist_id

        artist_params = params.permit(:name, :age)
        artist = Artist.create(artist_id: artist_id, name: artist_name, age: artist_age, albums_url: albums_url, tracks_url: tracks_url, self: self_url)

        if artist.save
          sts = :created
        else
          sts = :bad_request
        end
      end 
      render json: {id: artist.artist_id, 
          name: artist.name, 
          age: artist.age, 
          albums: artist.albums_url,
          tracks: artist.tracks_url,
          self: artist.self},status: sts
    end
  end

  def index
  	artists = Artist.order('created_at DESC');
    artists_json = []
    artists.each do |artist|
      json = {id: artist.artist_id, name: artist.name, age: artist.age, albums: artist.albums_url, tracks: artist.tracks_url, self: artist.self}
      artists_json.push(json)
    end
    render json: artists_json,status: :ok
  end

  def show
    if Artist.exists?(artist_id: params[:a_id])
    	artist = Artist.find_by(artist_id: params[:a_id])
    	render json: {id: artist.artist_id, 
        name: artist.name, 
        age: artist.age, 
        albums: artist.albums_url,
        tracks: artist.tracks_url,
        self: artist.self},status: :ok
    else
      render status: :not_found
    end
  end

  def show_albums
    if Artist.exists?(artist_id: params[:a_id])
      artist = Artist.find_by(artist_id: params[:a_id])
      albums = Album.where(artist_id: artist.id)

      albums_json = []
      albums.each do |album|
        json = {id: album.album_id, name: album.name, genre: album.genre, artist: album.artist_url, tracks: album.tracks_url, self: album.self_url}
        albums_json.push(json)
      end
      render json: albums_json,status: :ok
    else 
      render status: :not_found
    end
  end

  def show_tracks
    if Artist.exists?(artist_id: params[:a_id])
      artist = Artist.find_by(artist_id: params[:a_id])
      tracks = Track.where(artist_id: artist.id)

      tracks_json = []
      tracks.each do |track|
        json = {id: track.track_id, name: track.name, duration: track.duration, times_played: track.times_played, artist: track.artist_url,
        album: track.album_url, self: track.self_url}
        tracks_json.push(json)
      end
      render json: tracks_json,status: :ok
    else
      render status: :not_found
    end
  end

  def play_tracks
    artist_id = params[:a_id]
    if Artist.exists?(artist_id: params[:a_id])    
      artist = Artist.find_by(artist_id: artist_id)
      tracks = Track.where(artist_id: artist.id)
      tracks.each do |track|
        tp = track.times_played
        ntp = tp + 1
        track.update_attribute(:times_played, ntp)
      end
      render status: :ok
    else
      render status: :not_found
    end
  end

  def delete
    if Artist.exists?(artist_id: params[:a_id])   
      artist = Artist.find_by(artist_id: params[:a_id])

      tracks = Track.where(artist_id: artist.id)
      tracks.each do |track|
        track.destroy
      end 

      albums = Album.where(artist_id: artist.id)
      albums.each do |album|
        album.destroy
      end 
      artist.destroy

      render status: :no_content
    else 
      render status: :not_found
    end
  end 
=begin
[
  {
    "id": "TWljaGFlbCBKYWNrc29u",
    "name": "Michael Jackson",
    "age": 21,
    "albums": "https://apihost.com/artists/TWljaGFlbCBKYWNrc29u/albums",
    "tracks": "https://apihost.com/artists/TWljaGFlbCBKYWNrc29u/tracks",
    "self": "https://apihost.com/artists/TWljaGFlbCBKYWNrc29u"
  }
]

article = Article.new(article_params)

        if article.save
          render json: {status: 'SUCCESS', message:'Saved article', data:article},status: :ok
        else
          render json: {status: 'ERROR', message:'Article not saved', data:article.errors},status: :unprocessable_entity
        end
      end


{
  "id": "TWljaGFlbCBKYWNrc29u",
  "name": "Michael Jackson",
  "age": 21,
  "albums": "https://apihost.com/artists/TWljaGFlbCBKYWNrc29u/albums",
  "tracks": "https://apihost.com/artists/TWljaGFlbCBKYWNrc29u/tracks",
  "self": "https://apihost.com/artists/TWljaGFlbCBKYWNrc29u"
}

=end

end