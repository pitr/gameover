begin
  require ::File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require "rubygems"
  require "bundler"
  Bundler.setup
end

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
  haml :index
end
