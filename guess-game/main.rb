require 'sinatra'
require 'haml'
require 'sass'

set :port, 9003

get '/' do
  haml File.read('./index.html.haml')
end

get '/index.css' do
  sass File.read('./index.css.sass')
end

get /(.*.js)/ do |name|
  send_file "./public#{name}"
end

