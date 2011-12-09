class TextNode

  attr_reader :text

  def initialize text
    @text = text
  end

  def to_formattable_texts formattings
    [FormattableText.new(text, formattings)]
  end

   def max_slide_number
    0
  end
  
  # Reporting
  def source
    "Text<#{@text[0..20].inspect}>"
  end
  
  def print_tree
  end
  
  def inspect
    "text<#{@text}>".inspect
  end

end