require 'nokogiri'
require 'json'
require 'net/http'

class Article
  ALL = {}

  def self.all
    ALL.values
  end

  def self.find_by_article_id_and_page_id(article_id, page_id)
    ALL["#{article_id}/#{page_id}"]
  end

  attr_reader :article_id, :page_id, :lines

  def initialize(article_id, page_id)
    @article_id = article_id
    @page_id = page_id
    @lines = []
  end

  def save!
    ALL["#@article_id/#@page_id"] = self
  end
end

class Line
  attr_reader :id, :text, :words

  def initialize(text)
    @id = SecureRandom.uuid
    @words = []
    @text = text
  end
end

class Word
  attr_reader :id, :text
  attr_accessor :frame

  def initialize(text)
    @id = SecureRandom.uuid
    @text = text
  end
end

class ArticleScraper
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

        x = (textarea.attr('x').to_i * SCALE[:level_scale] / SCALE[:maxLevel_scale]).floor + (SCALE[:level_offset_x] + SCALE[:viewer_x]).floor
        y = (textarea.attr('y').to_i * SCALE[:level_scale] / SCALE[:maxLevel_scale]).floor + (SCALE[:level_offset_y] + SCALE[:viewer_y]).floor
        width = (textarea.attr('ww').to_i * SCALE[:level_scale]).floor
        height = (textarea.attr('wh').to_i * SCALE[:level_scale]).floor

        # adjust fit
        x -= EXPAND_SIZE_BY
        y -= EXPAND_SIZE_BY
        width += EXPAND_SIZE_BY * 2
        height += EXPAND_SIZE_BY * 2

        line.words[0].frame = {
          x: x,
          y: y,
          width: width,
          height: height
        }
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