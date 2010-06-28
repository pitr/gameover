require 'rubygems'
require 'sinatra'
require 'haml'
require 'sinbook'

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
  haml :index
end
