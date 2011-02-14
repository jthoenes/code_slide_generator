module PowerPoint
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
end