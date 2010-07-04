begin
  require ::File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require "rubygems"
  require "bundler"
  Bundler.setup
end

require 'sinatra'
require 'haml'
require 'model/user'

configure do
  enable :sessions
  enable :logging

  require 'uri'
  if ENV['MONGOHQ_URL']
    mongo_uri = URI.parse(ENV['MONGOHQ_URL'])
    ENV['MONGOID_HOST'] = mongo_uri.host
    ENV['MONGOID_PORT'] = mongo_uri.port.to_s
    ENV['MONGOID_USERNAME'] = mongo_uri.user
    ENV['MONGOID_PASSWORD'] = mongo_uri.password
    ENV['MONGOID_DATABASE'] = mongo_uri.path.gsub("/", "")
  end
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
