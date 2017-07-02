ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require 'data_mapper'
require 'dm-postgres-adapter'
require_relative 'models/peep.rb'
require_relative 'models/user.rb'

class Chitter < Sinatra::Base

require_relative 'data_mapper_setup'
enable :sessions
set :session_secret, 'super secret'

  get '/' do
    @peeps = Peep.all.reverse
    erb :'/peeps/index'
  end

  get '/peeps/new' do
    erb :'/peeps/new'
  end

  post '/peeps/new' do
    peep = Peep.create(name: params[:name],
    message: params[:message],
    created_at: params[:created_at])
    redirect '/'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users/new' do
    user = User.create(name: params[:name],
    user_name: params[:user_name],
    email: params[:email],
    password: params[:password])
    session[:user_id] = user.id
    redirect '/'
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  run! if app_file == $0
end
