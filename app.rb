require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'pry'
require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
  def current_area
    Area.find_by(id: session[:area])
  end

end

get '/' do
  erb :firstpage
end

get '/signup' do
  erb :sign_up
end


post '/signup' do
  user = User.create(
    name: params[:name],
    password: params[:password],
    password_confirmation: params[:password_confirmation]
  )
  if user.persisted?
    session[:user] = user.id
  end
   redirect '/userpage'
end

post '/signin' do
  user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
    redirect '/userpage'
  else
    redirect '/'
  end
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end

get '/userpage' do
  @areas = Area.all
  erb :user_page
end

post '/areas/:id' do
  area = Area.find(params[:id])
  session[:area] = area.id
  #@areaをcafe_listsに渡す
  redirect '/cafelists'
end

get '/cafelists' do
  @caves = Cafe.all
  erb :cafe_lists
 end

post '/cafepost/:id' do
  #binding.pry
  #binding.pry
  area.cafe.create(
    cafe_name: params[:cafename],
    cafe_place: params[:cafeplace],
    seat_num: params[:seatnum].to_i
  )
  #@cafe = Cafe.all
  #@area = area
  redirect '/cafelists'
end

get '/caves/:id/edit' do
  @cafe = Cafe.find(params[:id])
  erb :edit
end

post '/caves/:id' do
  cafe = Cafe.find(params[:id])
  cafe.cafe_name = params[:cafename]
  cafe.cafe_place = params[:cafeplace]
  cafe.seat_num = params[:seatnum]
  cafe.save
  redirect '/cafelists'
end

post '/caves/:id/delete' do
  cafe = Cafe.find(params[:id])
  cafe.destroy
  redirect '/cafelists'
end
