begin
  require ::File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require "rubygems"
  require "bundler"
  Bundler.setup
end

require 'sinatra'
require 'lilypad'
require 'haml'
require 'model/user'

configure do
  enable :sessions
  enable :logging
end

configure :production do
  use Rack::Lilypad do
    api_key ENV['HOPTOAD_API']
    sinatra
  end

  enable :raise_errors

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

get '/error' do
  haml :blah
end
