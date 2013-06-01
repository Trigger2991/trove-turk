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
              },          
              {
                id: "00001",
                image: "http://localhost:9001/word/00001.jpg"
              }

            ]
          }
        ]
      }
    ]

    article = random_element(articles)
    line = random_element(article[:lines])
    word = random_element(line[:words])

    question = {
      id: word[:id],
      image: word[:image]
    }
    question.to_json
end

def random_element(list)
  index = Random.rand(list.size)
  list[index]
end
