require 'rubygems'
require 'sinatra'
require 'haml'

configure :production do
  APP_ID = ENV['app_id']
  APP_SECRET = ENV['app_secret']
end

helpers do
  def get_cookie
    request.cookies['fbs_' + APP_ID]
  end
end

not_found do
  'oops'
end

error do
  'err ' + ENV['sinatra.error'].name
end

get '/canvas/' do
  cookie = get_cookie
  haml :index
end
