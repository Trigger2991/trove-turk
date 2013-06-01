require 'sinatra'
require 'json'
require 'net/http'

set :port, 9005

get '/feedback' do
  answers = fetch_answers
  summary = summarise(answers)
  summary.to_json
end

def fetch_answers
  uri = URI('http://localhost:9004/answers')
  res = Net::HTTP.get(uri)
  JSON.parse(res)
end

def new_summary
  init = Hash.new {|h,k|
     h[k] = Hash.new(count = 0) 
  }
end

def summarise(answers)
  answers.reduce(new_summary) do |summary, answer|
    summary[answer['id']][answer['text']] += 1
    summary
  end
end
