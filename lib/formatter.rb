class Formatter

  attr_writer :slide_number
  attr_writer :format_command

  def initialize
    
  end
  
  def active_formats current_slide_number
    if current_slide_number == slide_number
	  @at_slide_numbers + @from_slide_numbers
	elsif current_slide_number > slide_numbers
	  @from_slide_numbers
	else
	  []
	end
  end
  
  
end