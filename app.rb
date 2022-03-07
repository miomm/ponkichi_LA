require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
app.rbでActiveRecordを使用するためにmodels.rbを読み込む
require './models'
セッション機能を使えるようにする
enable :sessions

#get '/' do
#    erb :index
#end

get '/' do
    erb :shrine
end

get '/fanclub' do
    erb :fanclub
end