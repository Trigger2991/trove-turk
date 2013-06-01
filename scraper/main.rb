require 'sinatra'
require 'json'
require './article_scraper'

set :port, 9001

get '/articles.json' do
  cache_control :no_cache
  content_type "application/json", :charset => 'utf-8'

  Article.all.map { |article|
    {
      article_id: article.article_id,
      page_id: article.page_id,
      lines: article.lines.map { |line|
        {
          id: line.id,
          full_text: line.text,
          words: line.words.map { |word|
            {
              id: word.id,
              text: word.text,
              frame: word.frame,
              image: 'blah'
            }
          }
        }
      }
    }
  }.to_json
end
