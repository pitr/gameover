require 'rubygems'
require 'sinatra'
require 'haml'

configure :test, :development do
  APP_ID = 'app_id'
  APP_SECRET = 'app_secret'
end

configure :production do
  APP_ID = ENV['app_id']
  APP_SECRET = ENV['app_secret']
end

helpers do
  def get_cookie
    request.cookies['fbs_' + APP_ID]
  end

  def fb_sig_and_params
    return nil, [] unless params['fb_sig']
    return params['fb_sig'], extract_fb_sig_params
  end

  def extract_fb_sig_params
    params.inject({}) do |collection, (param, value)|
      collection[param.sub(/^fb_sig_/, '')] = value if param[0,7] == 'fb_sig_'
      collection
    end
  end

  def signature_is_valid?(fb_params, actual_sig)
    raw_string = fb_params.map{ |*args| args.join('=') }.sort.join
    expected_signature = Digest::MD5.hexdigest([raw_string, APP_SECRET].join)
    actual_sig == expected_signature
  end

  def convert_parameters!(params)
    params.each do |key, value|
      case key
      when 'fb_sig_added', 'fb_sig_in_canvas', 'fb_sig_in_new_facebook', 'fb_sig_position_fix', 'fb_sig_is_ajax'
        params[key] = value == "1"
      when 'fb_sig_expires', 'fb_sig_profile_update_time', 'fb_sig_time'
        params[key] = value == "0" ? nil : Time.at(value.to_f)
      when 'fb_sig_friends'
        params[key] = value.split(',')
      end
    end
  end
end

before do
  sig, params = fb_sig_and_params
  @cookie = convert_paramteres!(params) if signature_is_valid?(params, sig)
end

not_found do
  'oops'
end

error do
  'err ' + ENV['sinatra.error'].name
end

get '/canvas/' do
  haml :index
end
