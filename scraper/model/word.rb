class Word
  attr_reader :id, :text
  attr_accessor :frame

  def initialize(text)
    @id = SecureRandom.uuid
    @text = text
  end
end