require 'rubygems'
require 'sinatra'
require 'haml'
require 'sinbook'
require 'oauth2'
require 'json'

configure :test, :development do
  APP_ID = 'app_id'
  APP_SECRET = 'app_secret'
  APP_KEY = 'app_key'
end

configure :production do
  APP_ID = ENV['app_id']
  APP_SECRET = ENV['app_secret']
  APP_KEY = ENV['app_key']
end

configure do
  DOMAIN = 'http://gameover.heroku.com/'
end

facebook do
  api_key APP_KEY
  secret APP_SECRET
  app_id APP_ID
  url 'http://apps.facebook.com/gameover'
  callback DOMAIN
end

helpers do
  def client
    OAuth2::Client.new(APP_ID, APP_SECRET, :site => 'https://graph.facebook.com')
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/canvas/callback'
    uri.query = nil
    uri.to_s
  end
end

not_found do
  'oops'
end

error do
  'err ' + ENV['sinatra.error'].name
end

get '/' do
  'hi'
end

get '/canvas/' do
  fb.require_login!
  redirect client.web_server.authorize_url(
    :redirect_uri => redirect_uri, 
    :fields => 'location'
  )
end

get '/canvas/callback' do
  access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
  user = JSON.parse(access_token.get('/me'))

  user.inspect
end
