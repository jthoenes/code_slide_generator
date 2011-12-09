class ShapeFormatter
  def initialize shape, formattable_texts, slide_range
    @shape = shape
    @formattable_texts = formattable_texts
	@slide_numbers = slide_range.to_a
  end
  
  def format index, slide
    shape = slide.shapes[@shape.index]
	shape.prepare!
		
	slide_number = @slide_numbers[index] || @slide_numbers.last
	@formattable_texts.each{|ft| ft.apply(slide_number, slide, shape) }
  end
  
  def slide_count
    @slide_numbers.length
  end
end