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

get '/shrine' do
    erb :shrine
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