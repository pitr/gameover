require 'rack_hoptoad'
require 'main'

use Rack::Hoptoad, ENV['HOPTOAD_API']

run Sinatra::Application
