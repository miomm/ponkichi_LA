require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
#app.rbでActiveRecordを使用するためにmodels.rbを読み込む
require './models'
#セッション機能を使えるようにする
enable :sessions
require 'open-uri'
require 'json'
require 'net/http'
require 'date'

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
    #@uranai = "piyo"
    #占い
    today = DateTime.now.new_offset("+09:00").strftime("%Y/%m/%d")
    seiza = params[:star]
    @name = params[:name]
    @uranai = {}
    if seiza.nil?
        # puts "nil"
        @uranai['ok'] = 0
    elsif seiza == "noselect"
        puts seiza
        puts "empty"
        @uranai['ok'] = 2
        @uranai['message'] = "星座を選択して下さい"
        
    else
        # puts "else"
        uri = URI("http://api.jugemkey.jp/api/horoscope/free/" + today)
            res = Net::HTTP.get_response(uri)
            @uranai['ok'] = 1
            json = JSON.parse(res.body)
            @uranai['data'] = json['horoscope'][today].find{|u| u['sign'] == seiza}
    end
    erb :shrine
end

post '/plus' do
     coin = Coin.first
     coin.number += 1
     coin.save
     redirect '/shrine?number=0'
 end
 
get '/fanclub' do
    @blogs = Blog.all
    puts @blogs
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

get '/azagyo' do
    @menu = {
        :ok => 0
    }
    erb :azagyo
end

get '/azagyo/result' do
    uri = URI("https://azabu-gyoza-api.herokuapp.com/api/v1/menu")
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    upper = 2000
    sum = 0
    result = json["result"]
    ans_arr = []
    1.step do |i|
        selected_list = result.select{ |x| x["price"] < (upper - sum) }
        if selected_list.empty?
            break
        else
            selected = selected_list[rand(selected_list.length)]
            sum += selected["price"]
            ans_arr << selected
        end
    end
    
    @menu = {
        :ok => 1,
        :price => sum,
        :result => ans_arr
    }
    erb :azagyo
end

get 'blogs/new' do
    erb :new
end

post '/blogs' do
    current_user.blogs.create(title: params[:title], body_text: params[:body_text])
    
    redirect '/fanclub'
end

post '/delete/:id' do
    Blog.find(params[:id]).destroy
    redirect '/fanclub'
end

get '/reset0427' do
    Coin.delete_all
    Count.delete_all
    Blog.delete_all
    redirect '/'
end