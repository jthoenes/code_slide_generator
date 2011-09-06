class TextItem

  attr_reader :text

  def initialize text
    @text = text
  end

  def formattable_texts commands
    [FormattableText.new(text, commands)]
  end

   def max_slide_number
    0
  end
  
  def inspect
    "text<#{@text}>".inspect
  end

end