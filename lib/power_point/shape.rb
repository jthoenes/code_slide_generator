module PowerPoint
  class Shape
	TEXT_FIELD_TYPE = 17.freeze
  
    attr_reader :slide
    attr_reader :index	
	
    def initialize slide, index, shape
	  @slide, @index, @shape = slide, index, shape
	  
	end
	
	def text_field?
	  @shape.Type == TEXT_FIELD_TYPE
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
	
	def prepare!
	  text_range.clear!
	end
	
	def text_range
	  @text_range ||= TextRange.new(@shape.TextFrame.TextRange)
	end
  end
end