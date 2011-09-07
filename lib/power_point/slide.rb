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
  
  class Slide
    def code_slide?
	  !(code_shapes.empty?)
	end
	
	def subsequent_generated_slides
	  subsequent_generated = []
	  
	  slide_number = self.number
	  loop do
	    # slide[1].number == 2
	    slide = presentation.slides[slide_number]
		
		if slide.generated?
		  subsequent_generated << slide
		else
	      break
	    end
		slide_number += 1
      end
	  
	  subsequent_generated
	end
	
	def code_shapes
	  shapes.select(&:code_shape?)
	end
	
	def generate_code_slides(basepath)
	  shape_formatters = code_shapes.map{ |shape| shape.formatter(basepath) }
	  max_slide_index = shape_formatters.map(&:slide_count).max - 1
	  
	  work_slide = self
	  (0..max_slide_index).each do |index|
	    work_slide = work_slide.duplicate
		work_slide.show!
		  
		shape_formatters.each{|fm| fm.format(index, work_slide) }
	  end
	end
	
	def to_s
	  "Slide #{number}"
	end
	
	def inspect
	  ret = "#<#{self.class.to_s} #{number}"
	  ret += " (code)" if code_slide?
	  ret += " (generated)" if generated?
	  ret += ">"
	  ret
	end
  end
end