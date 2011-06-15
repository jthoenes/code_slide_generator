module PowerPoint
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
end