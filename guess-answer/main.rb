require 'sinatra'
require 'json'
require 'sinatra/cross_origin'

set :port, 9004
set :allow_origin, :any
set :allow_methods, [:get, :post, :options]
set :allow_credentials, true
set :protection, :origin_whitelist => ['http://localhost:9003']

configure do
  enable :cross_origin
end

answers = []

post '/answers/new' do
  cache_control :no_cache
  cross_origin
  content_type "application/json", :charset => 'utf-8'
  data = JSON.parse(request.body.read)
  answers.push({
    'id' => data['id'],
    'text' => data['text']
  })
  nil
end

options '/answers/new' do
  cross_origin
  response['Access-Control-Allow-Headers'] = 'Content-Type'
  ''
end


get '/answers' do
  cache_control :no_cache
  content_type "application/json", :charset => 'utf-8'
  answers.to_json
end
