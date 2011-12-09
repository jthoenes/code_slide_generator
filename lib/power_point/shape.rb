module PowerPoint
  class Shape
	MSO_FALSE = 0
  
    attr_reader :slide
    attr_reader :index	
	
    def initialize slide, index, shape
	  @slide, @index, @shape = slide, index, shape
	end
	
	def text_field?
	  @shape.TextFrame.HasText != MSO_FALSE
	end
	
	def text
	  text_range.text
	end
	
	def add_text text
	  text_range.add_text(text)
	end
	
	def presentation
	  slide.presentation
	end
	
	def background_color
	  RGB.from_rgb_value(@shape.Fill.ForeColor.RGB)
	end
	
	def prepare!
	  text_range.clear!
	end
	
	def text_range
	  @text_range ||= TextRange.new(self, @shape.TextFrame.TextRange)
	end
  end
  
  class Shape
    def code_shape?
	  get_formatter.code_shape?
	end
    
    def formatter(basepath)
      get_formatter.parse(basepath)
      get_formatter
    end
	
    private
	def get_formatter
	  @formatter ||= ShapeFormatter.new(self)
	end
	
  end
end