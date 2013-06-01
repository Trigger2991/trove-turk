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