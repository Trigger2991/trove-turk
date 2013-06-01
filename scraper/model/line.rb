class Line
  attr_reader :id, :text, :words

  def initialize(text)
    @id = SecureRandom.uuid
    @words = []
    @text = text
  end
end