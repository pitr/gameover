require 'rubygems'
require 'sinatra'
require 'haml'

configure do
  enable :sessions
  enable :logging
end

helpers do
end

not_found do
  'oops'
end

error do
  'err ' + ENV['sinatra.error'].name
end

get '/' do
  if session['location']
    @games = ['a', 'b', 'c']
    haml :index
  else
    haml :location
  end
end

post '/location' do
  session['location'] = params[:loc]
  redirect '/'
end

post '/add' do
end
