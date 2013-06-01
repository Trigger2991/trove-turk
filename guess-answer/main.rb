require 'sinatra'
require 'json'

set :port, 9004

data_store = []

post '/answer' do
  content_type "application/json", :charset => 'utf-8'
  data = JSON.parse(request.body.read)
  data_store.push(data)
  nil
end


get '/answer' do
  cache_control :no_cache
  content_type "application/json", :charset => 'utf-8'
  data_store.to_json
end
