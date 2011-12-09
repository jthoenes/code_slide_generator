class FormattableText

  attr_accessor :text

  def initialize text, formattings
    @text, @formattings = text, formattings
  end
  
  def apply slide_number, slide, shape
    if on_slide?(slide_number)
      unless text.empty?
	    text_range = shape.add_text(text)
		text_range.reset_format!
	    formattings_for_slide(slide_number, text_range)
	  end
    end
  end
  
  private
  def formattings_for_slide slide_number, text_range
     @formattings.relevant_formats(slide_number).each{|format| format.apply(text_range)}
  end

  def on_slide? slide_number
    ! @formattings.relevant_formats(slide_number).any?{|cmd| cmd.delete?}
  end
end