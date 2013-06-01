require 'nokogiri'
require 'json'
require 'net/http'
require './model/article'
require './model/line'
require './model/word'

class ArticleScraper
  TEMP_ARTICLE_IMAGE = 'img.jpg'
  EXPAND_SIZE_BY = 4
  SCALE = {
    level_scale: 0.67,
    maxLevel_scale: 1.0,
    level_offset_x: 777,
    level_offset_y: 340,
    viewer_x: -2846.0,
    viewer_y: -612
  }

  def scrape_url(url)
    if /\/(?<article_id>\d+)\/(?<page_id>\d+)/ =~ url
      puts "Found Article##{article_id} with Page##{page_id}"
      article = Article.find_by_article_id_and_page_id(article_id, page_id) || Article.new(article_id, page_id)
      article.lines.clear

      Nokogiri::HTML.parse(get_url "http://trove.nla.gov.au/ndp/del/articleForEdit/#{article_id}/#{page_id}").search('textarea').each do |textarea|
        line = Line.new textarea.content
        article.lines << line

        line.text.split(/\s+/).each do |word|
          line.words << Word.new(word)
        end

        line.words[0].frame = expand({
          x: (textarea.attr('x').to_i * SCALE[:level_scale] / SCALE[:maxLevel_scale]).floor + (SCALE[:level_offset_x] + SCALE[:viewer_x]).floor,
          y: (textarea.attr('y').to_i * SCALE[:level_scale] / SCALE[:maxLevel_scale]).floor + (SCALE[:level_offset_y] + SCALE[:viewer_y]).floor,
          width: (textarea.attr('ww').to_i * SCALE[:level_scale]).floor,
          height: (textarea.attr('wh').to_i * SCALE[:level_scale]).floor
        }, EXPAND_SIZE_BY)

        line.words.each do |word|
          next unless word.frame

          extract_word_from_image TEMP_ARTICLE_IMAGE, word
        end
      end

      puts "Found #{article.lines.count} lines with #{article.lines.map { |l| l.words.count }.inject(&:+)} words"
      article.save!
    else
      raise "Couldn't find article_id and page_id in URL"
    end
  end

  private
  def get_url(url)
    puts "GET #{url}"
    Net::HTTP.get URI(url)
  end

  def expand(rect, by)
    {
      x: rect[:x] + by,
      y: rect[:y] + by,
      width: rect[:width] + (by * 2),
      height: rect[:height] + (by * 2)
    }
  end

  def extract_word_from_image(image, word)
    `convert -crop '#{word.frame[:width]}x#{word.frame[:height]}+#{word.frame[:x]}+#{word.frame[:y]}' #{image} words/#{word.id}.jpg`
  end
end

scraper_worker = Thread.new do
  scraper = ArticleScraper.new
  
  while true
    begin
      scraper.scrape_url 'http://trove.nla.gov.au/ndp/del/article/4256657/826890?zoomLevel=3#pstart826890'
    rescue => ex
      puts ex
    end

    sleep 120
  end
end