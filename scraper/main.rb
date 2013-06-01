require 'sinatra'
require 'json'

set :port, 9001

get '/articles.json' do
  cache_control :no_cache
  content_type "application/json", :charset => 'utf-8'
  [
    { 
      lines: [
        { 
          words: [
            {
              id: "asdkjhg",
              image: "http://localhost:9001/word/asdkjhg.jpg"
            },          
            {
              id: "00001",
              image: "http://localhost:9001/word/00001.jpg"
            }

          ]
        }
      ]
    }
  ].to_json
end
