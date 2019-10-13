require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
#require 'pry'
require 'sinatra/activerecord'
require './models'
require 'date'
require 'time'

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

  def format_date(date)
    jst_datetime = date.in_time_zone('Tokyo')

  end

end

get '/' do
  erb :firstpage
end

get '/signup' do
  erb :sign_up
end

get '/signin' do
  erb :sign_in
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

get '/home' do
  erb :firstpage
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
  @out_users = current_cafe.users.where.not(out_time: nil).limit(5).order("updated_at desc")
  @go_users = current_cafe.users.where.not(go_time: nil).limit(5).order("updated_at desc")
  erb :cafe_want
end

post '/cafe_go' do
  current_user.update(
    go_time: params[:go],
    date: format_date(Date.today)
  )

  current_user.out_time = nil
  current_user.save

  UserCafe.create(
    user_id: current_user.id,
    cafe_id: current_cafe.id
  )
  @go_users = current_cafe.users.where.not(go_time: nil).limit(5).order("updated_at desc")
  # @go_users.each do |go_user|
  #   if (go_user.date - format_date(Date.today)) < 0
  #     go_user.destroy
  #     go_user.save
  #   end
  # end
  @out_users = current_cafe.users.where.not(out_time: nil).limit(5).order("updated_at desc")
  # @out_users.each do |out_user|
  #   if (out_user.date - format_date(Date.today)) < 0
  #     out_user.destroy
  #     out_user.save
  #   end
  # end
##KONOカフェに行きたい人の配列にぶち込みたい
  erb :cafe_want
end

get '/caves/:id/now' do
  cafe = Cafe.find(params[:id])
  session[:cafe] = cafe.id
  @out_users = current_cafe.users.where.not(out_time: nil).limit(5).order("updated_at desc")
  @go_users = current_cafe.users.where.not(go_time: nil).limit(5).order("updated_at desc")
  # @out_users = current_cafe.users.where.not(out_time: nil)
  # @out_users.each do |out_user|
  #   if (out_user.date - format_date(Date.today)) < 0
  #     out_user.destroy
  #     out_user.save
  #   end
  # end
  # @go_users = current_cafe.users.where.not(go_time: nil)
  # @go_users.each do |go_user|
  #   if (go_user.date - format_date(Date.today)) < 0
  #     go_user.destroy
  #     go_user.save
  #   end
  # end

  erb :cafe_now
end

post '/cafecongestion' do
  current_cafe.update(
    congestion: params[:congestion]
  )
  @out_users = current_cafe.users.where.not(out_time: nil).limit(5).order("updated_at desc")
  @go_users = current_cafe.users.where.not(go_time: nil).limit(5).order("updated_at desc")
  #binding.pry
  erb :cafe_now
end

post '/cafe_go_out' do
  current_user.update(
    out_time: params[:go_out],
    date: Date.today
  )


  current_user.go_time = nil
  current_user.save
  #binding.pry
  UserCafe.create(
    user_id: current_user.id,
    cafe_id: current_cafe.id
  )
  #上によってこのような関係が使える
  @out_users = current_cafe.users.where.not(out_time: nil).limit(5).order("updated_at desc")
  # @out_users.each do |out_user|
  #   if (out_user.date - format_date(Date.today)) < 0
  #     out_user.destroy
  #     out_user.save
  #   end
  # end
  @go_users = current_cafe.users.where.not(go_time: nil).limit(5).order("updated_at desc")
  # @go_users.each do |go_user|
  #   if (go_user.date - format_date(Date.today)) < 0
  #     go_user.destroy
  #     go_user.save
  #   end
  # end
  erb :cafe_now
end