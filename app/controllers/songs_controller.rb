require 'rack-flash'
class SongsController < ApplicationController

  use Rack::Flash

  get '/songs' do
    @songs = Song.all

    erb :'/songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all
    @artists = Artist.all
    erb :'songs/new'
  end

  post '/songs' do
    @song = Song.find_or_create_by(name: params['song']['name'])

    @artist = Artist.find_or_create_by(name: params['artist']['name'])
    @song.artist_id = artist.id

    @song.genre_ids = params["genres"]
    @song.save
    flash[:message] = "Successfully Created New Song!"

    redirect "/songs/#{song.slug}"
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])

    erb :'songs/show'
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    @genres = Genre.all
    erb :'songs/edit'
  end

  patch '/songs/:slug' do

    @song = Song.find_by_slug(params[:slug])

    if @song.name != params['song']['name']
      @song.update(name: params['song']['name'])
      @song.name = Song.find_or_create_by(name: params[:song][:name])
    end
    @song.update(params[:song])

    if @song.artist.name != params['artist']['name']
       @song.artist = Artist.find_or_create_by(name: params[:artist][:name])
    end


    if @song.genre_ids != params['genres']
       @song.genre_ids = params['genres']
    end

    @song.save
    flash[:message] = "Successfully Updated Song"
    redirect "/songs/#{@song.slug}"
  end

end
