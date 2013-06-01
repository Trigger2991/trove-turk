require 'sinatra'
require 'json'
require 'net/http'
require 'sinatra/cross_origin'

set :port, 9002
set :allow_origin, :any
set :allow_methods, [:get, :post, :options]
set :allow_credentials, true
set :protection, :origin_whitelist => ['http://localhost:9003']

configure do
  enable :cross_origin
end

get '/question.json' do
  cache_control :no_cache
  cross_origin
  content_type "application/json", :charset => 'utf-8'
  
  articles = fetch_articles
  article = random_element(articles)
  line = random_element(article["lines"])
  word = line["words"].first
  #word = random_element(line["words"])

  {
    id: word["id"],
    image: word["image"]
  }.to_json
end

options '/question.json' do
  cross_origin
  response['Access-Control-Allow-Headers'] = 'Content-Type'
  ''
end

def random_element(list)
  index = Random.rand(list.size)
  list[index]
end

def fetch_articles
  uri = URI('http://localhost:9001/articles.json')
  res = Net::HTTP.get(uri)
  JSON.parse(res)
end
