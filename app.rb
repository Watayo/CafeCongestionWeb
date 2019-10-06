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

  def current_cafe
    Cafe.find_by(id: session[:cafe])
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
  current_area.caves.create(
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

get '/caves/:id/want' do
  cafe = Cafe.find(params[:id])
  session[:cafe] = cafe.id
  erb :cafe_want
end

get '/caves/:id/now' do
  cafe = Cafe.find(params[:id])
  session[:cafe] = cafe.id
  #

  #
  erb :cafe_now
end

post '/cafecongestion' do
  current_cafe.create(
    congestion: params[:congestion]
  )
  #binding.pry
  erb :cafe_now
end

post '/cafe_go_out' do
  #ちょっと中間テーブルやばい
  #go_out_time = params[:go_out]
  current_user.update(
    out_time: params[:go_out]
  )

  #binding.pry
  relation = UserCafe.create(
    user_id: current_user.id,
    cafe_id: current_cafe.id
  )
  #中間テーブルを使って、格納したい
  #binding.pry
  @out_users.push(User.find_by(id: relation.user_id))
  erb :cafe_now
  #binding.pry
end