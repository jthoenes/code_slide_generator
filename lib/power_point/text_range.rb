module PowerPoint
  class TextRange
    def initialize text_range
	  @text_range = text_range
	end
	
	def text
	  @text_range.text
	end
	
	def add_text text
	  start_position = @text_range.Length+1
      @text_range.InsertAfter text
	  
	  TextRange.new(@text_range.Characters(start_position, text.length))
	end
	
	def clear!
	  @text_range.Text = ""
	end
	
	def reset_format!
      unbold!
      self.font_family="Courier New"
      black!
	  self.font_size = 20
	end
	
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
	  @text_range.Font.Color.RGB = "78635A".hex
	end
	
	def white!
	  @text_range.Font.Color.RGB = "FFFFFF".hex
	end
	
	def red!
	  @text_range.Font.Color.RGB = "78635A".hex
	end
  end
end