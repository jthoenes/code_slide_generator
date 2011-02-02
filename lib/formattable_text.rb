class FormattableText

  attr_accessor :text

  def initialize text, commands
    @text, @commands = text, commands
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
     relevant_commands(slide_number).map{|cmd| cmd.formattings(slide_number, text_range)}.flatten.uniq
  end

  def on_slide? slide_number
    ! relevant_commands(slide_number).any?{|cmd| cmd.prevent_insert(slide_number)}
  end

  def relevant_commands slide_number
    @commands.reject do |cmd1|
      @commands.any? { |cmd2| cmd2.reject(cmd1, slide_number) }
    end
  end
end