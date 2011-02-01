class FormattableText

  attr_accessor :text

  def initialize text, commands
    @text, @commands = text, commands
  end

  def apply slide_number, slide
    if on_slide? slide_number
      p [text, formattings_for_slide(slide_number)]
    end
  end

  private
   def formattings_for_slide slide_number
     relevant_commands(slide_number).map{|cmd| cmd.formattings(slide_number)}.flatten.uniq
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