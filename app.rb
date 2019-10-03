require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
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
  @area = Area.find(params[:id])
  #@areaをcafe_listsに渡す
  erb :cafe_lists
end

get '/cafelist' do
  @cafes = Cafe.all
  erb :cafe_lists
end

post '/cafepost/:id' do
  area = Area.find(params[:id])
  area.cafe.create(
    cafe_name: params[:cafename],
    seat_num: params[:seatnum],
    cafe_place: params[:cafeplace]
  )
  redirect '/cafelist'
end