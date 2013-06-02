require 'sinatra'
require 'haml'
require 'sass'
require 'sinatra/cross_origin'

set :port, 9006

set :allow_origin, :any
set :allow_methods, [:get, :post, :options]
set :allow_credentials, true
set :protection, :origin_whitelist => ['*']

get '/' do
  cross_origin
  haml File.read('./index.html.haml')
end

options '/' do
  cross_origin
  response['Access-Control-Allow-Headers'] = 'Content-Type,X-Requested-With'
  ''
end

get '/index.css' do
  sass File.read('./index.css.sass')
end

get /(.*.js)/ do |name|
  send_file "./public#{name}"
end