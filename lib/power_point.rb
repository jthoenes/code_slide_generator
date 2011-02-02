module PowerPoint
  class Application
    def initialize
      @ppt = WIN32OLE.new('PowerPoint.Application')
    end
    
    def current_presentation
      Presentation.new @ppt.ActivePresentation
    end
  end
  
  class Presentation
    def initialize presentation
	  @presentation = presentation
	end
	
	def slides
	  slides = []
	  @presentation.Slides.each {|slide| slides << Slide.new(self, slide)}
	  slides
	end
	
	def all_shapes
	  slides.map{|slide| slide.shapes}.flatten
	end
	
	def select_shapes &block
	  all_shapes.select(&block)
	end
  end
  
  class Slide
    GENERATED_TAG_NAME = "GENERATED".freeze
	TRUE_TAG_VALUE = "TRUE".freeze
  
    attr_reader :presentation
  
   def initialize presentation, slide
     @presentation, @slide = presentation, slide
   end
   
   def shapes
     shapes = []
	 index = 0
	 @slide.Shapes.each do 
		|shape| shapes << Shape.new(self, index, shape)
		index += 1
	 end
	 shapes
   end
   
   def delete
     @slide.Delete
   end
   
   def duplicate
     copy = @slide.Duplicate
	 copy.Tags.Add(GENERATED_TAG_NAME, TRUE_TAG_VALUE)
	 Slide.new(@presentation, copy)
   end
   
   def generated?
     value = @slide.Tags.Item(GENERATED_TAG_NAME)
	 (not value.nil?) and value.upcase == TRUE_TAG_VALUE
   end
   
   def hide!
     @slide.SlideShowTransition.Hidden = -1
   end
   
   def show!
     @slide.SlideShowTransition.Hidden = 0
   end
   
   def select!
     @slide.Select
   end
   
   def number
     @slide.SlideNumber
   end
   
  end
  
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
	  self.font_size = 15
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
	  @text_range.Font.Color.RGB = "000000".hex
	end
	
	def white!
	  @text_range.Font.Color.RGB = "FFFFFF".hex
	end
	
	def red!
	  @text_range.Font.Color.RGB = "0000FF".hex
	end
  end
end