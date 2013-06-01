require 'sinatra'
require 'json'
require 'net/http'

set :port, 9002

get '/question.json' do
    cache_control :no_cache
    content_type "application/json", :charset => 'utf-8'
    
    articles = fetch_articles
    article = random_element(articles)
    line = random_element(article["lines"])
    word = random_element(line["words"])

    {
      id: word["id"],
      image: word["image"]
    }.to_json
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
