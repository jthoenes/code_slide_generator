module PowerPoint
  class TextRange
    def initialize shape, text_range
	  @shape, @text_range = shape, text_range
	end
	
	def text
	  begin
	    return @text_range.Text
	  rescue
	    return ""
	  end
	end
	
	def add_text text
	  start_position = @text_range.Length+1
      @text_range.InsertAfter text
	  
	  TextRange.new(@shape, @text_range.Characters(start_position, text.length))
	end
	
	def clear!
	  @text_range.Text = ""
	end
	
	def reset_format!
      unbold!
      black!
	end
	
	def background_color
	  @shape.background_color
	end
	
	def bold= value
	  @text_range.Font.Bold = (value ? 1 : 0)
	end
	
	def color= color
	  @text_range.Font.Color.RGB = color.to_rgb_value
	end
	
	# Old stuff
	def font_family=(font_family)
	  @text_range.Font.Name = font_family
	end
	
	def font_size=(font_size)
	  @text_range.Font.Size = font_size
	end
	
	def bold!
	  @text_range.Font.Bold = 1
	end
	
	def unbold!
	  @text_range.Font.Bold = 0
	end
	
	def black!
	  @text_range.Font.Color.RGB = "000000".hex
	end
	
	def white!
	  @text_range.Font.Color.RGB = 	@shape.background_color
	end
	
	def red!
	  @text_range.Font.Color.RGB = "0000D2".hex
	end
  end
end