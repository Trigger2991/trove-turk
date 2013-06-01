require 'sinatra'
require 'json'

set :port, 9002

get '/question.json' do
    cache_control :no_cache
    content_type "application/json", :charset => 'utf-8'
    articles = [
      { 
        lines: [
          { 
            words: [
              {
                id: "asdkjhg",
                image: "http://localhost:9001/word/asdkjhg.jpg"
              }
            ]
          }
        ]
      }
    ]
    

    word = articles.first[:lines].first[:words].first

    question = {
      id: word[:id],
      image: word[:image]
    }
    question.to_json
end
