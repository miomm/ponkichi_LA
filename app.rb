require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
#app.rbでActiveRecordを使用するためにmodels.rbを読み込む
require './models'
#セッション機能を使えるようにする
enable :sessions

get '/' do
    erb :index
end

before '/shrine' do
  if Coin.all.size == 0
    Coin.create(number: 0)
  end
  if Count.all.size == 0
    Count.create(number: 0)
  end
end

get '/shrine' do
    @number = Coin.first.number
    #アクセスカウンター
    @counter = Count.first.number
    number = params[:number] || 1
    count = Count.first
     count.number += number.to_i
     count.save
    #占い
    #uri = URI("")
    erb :shrine
end

post '/plus' do
     coin = Coin.first
     coin.number += 1
     coin.save
     redirect '/shrine?number=0'
 end
 
get '/fanclub' do
    erb :fanclub
end

get '/signin' do
    erb :signin
end

post '/signin' do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
    redirect '/fanclub'
end

get '/signup' do
    erb :signup
end

post '/signup' do
    p params[:email]
    p params[:password]
    user = User.create(
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
    )
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/fanclub'
end

helpers do
    def current_user
        User.find_by(id: session[:user])
    end
end

before '/fanclub' do
    if current_user.nil?
        redirect '/signin'
    end
end

get '/signout' do
    session[:user] = nil
    redirect '/signin'
end