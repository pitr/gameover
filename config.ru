require 'main'

require 'lilypad'

use Rack::Lilypad do
  api_key '9282ab6ad1ee7734c24e94be245e4d58'
  sinatra
end

run Sinatra::Application
