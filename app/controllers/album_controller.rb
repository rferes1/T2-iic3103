require "base64"
require 'json'

class AlbumController < ApplicationController
  def new
    a_id = params[:a_id]
    album_name = params[:name]
    album_genre = params[:genre]

    string =  album_name + ":" + a_id
    album_id = Base64.encode64(string).delete!("\n")
    if album_id.length > 22
      album_id = Base64.encode64(string).delete!("\n")[0,22]
    end 

  	artist_id = Artist.find_by(artist_id: a_id).id

    nombre_app = "localhost:3000"
    artist_url = nombre_app + "/artists/" + a_id
    self_url = nombre_app + "/albums/" + album_id
    tracks_url = nombre_app + "/" + album_id + "/tracks"

    album_params = params.permit(:name, :genre, :a_id)
  	album = Album.create(album_id: album_id, name: album_name, genre: album_genre, 
      artist_url: artist_url, tracks_url: tracks_url, self_url: self_url, artist_id: artist_id)

    if album.save
      render json: {id: album.album_id, 
      name: album.name, 
      age: album.genre, 
      albums: album.artist_url,
      tracks: album.tracks_url,
      self: album.self_url},status: :ok
    else
      render json: {id: album.album_id, 
      name: album.name, 
      age: album.genre, 
      albums: album.artist_url,
      tracks: album.tracks_url,
      self: album.self_url},status: :unprocessable_entity
    end
  end

  def index
    albums = Album.order('created_at DESC');
    albums_json = []
    albums.each do |album|
      json = {id: album.album_id, name: album.name, age: album.genre, artist: album.artist_url, tracks: album.tracks_url, self: album.self_url}
      albums_json.push(json)
    end
    render json: albums_json,status: :ok
  end

  def show
    album = Album.find_by(album_id: params[:album_id])
    render json: {id: album.album_id, 
      name: album.name, 
      age: album.genre, 
      albums: album.artist_url,
      tracks: album.tracks_url,
      self: album.self_url},status: :ok
  end

  def show_tracks
    album = Album.find_by(album_id: params[:album_id])
    tracks = Track.where(album_id: album.id)

    tracks_json = []
    tracks.each do |track|
      json = {id: track.track_id, name: track.name, duration: track.duration, times_played: track.times_played, artist: track.artist_url,
      album: track.album_url, self: track.self_url}
      tracks_json.push(json)
    end
    render json: tracks_json,status: :ok
  end

  def play_tracks
    album_id = params[:album_id]
    album = Album.find_by(album_id: album_id)
    tracks = Track.where(album_id: album.id)
    tracks.each do |track|
      tp = track.times_played
      ntp = tp + 1
      track.update_attribute(:times_played, ntp)
    end 
  end

  def delete
    album = Album.find_by(album_id: params[:album_id])
    tracks = Track.where(album_id: album.id)
    tracks.each do |track|
      track.destroy
    end 
    album.destroy
  end

end

=begin
GET /artists: retorna todos los artistas.
GET /albums: retorna todos los álbums.
GET /tracks: retorna todas las canciones.
GET /artists/<artist_id>: retorna el artista <artist_id>.
GET /artists/<artist_id>/albums: retorna todos los albums del artista <artist_id>.
GET /artists/<artist_id>/tracks: retorna todas las canciones del artista <artist_id>.
GET /albums/<album_id>: retorna el álbum <album_id>.
GET /albums/<album_id>/tracks: retorna todas las canciones del álbum <album_id>.
GET /tracks/<track_id>: retorna la canción <track_id>.
=end