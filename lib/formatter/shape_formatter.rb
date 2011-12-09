class ShapeFormatter
  INCLUDE_COMMAND = "INCLUDE_SOURCE".freeze

  def initialize shape
    @shape = shape
  end
  
  def parse(basepath)
    # find and read textfile
    filepath = code_filepath(basepath)
	text = read_text(filepath)
    
    # parse the text
	parser = create_parser(filepath, text)
    root_node = parser.parse
      
	@slide_numbers = calculate_slide_numbers(root_node.max_slide_number)
    @formattable_texts = root_node.formattable_texts(Formattings.new)
  end
  
  def format index, slide
    shape = slide.shapes[@shape.index]
	shape.prepare!
		
	slide_number = @slide_numbers[index] || @slide_numbers.last
	@formattable_texts.each{|ft| ft.apply(slide_number, slide, shape) }
  end
  
  def code_shape?
    @shape.text_field? and @shape.text.strip =~ /#{INCLUDE_COMMAND}=(.+)$/
  end
  
  def slide_count
    @slide_numbers.length
  end
  
  private
  def code_filepath basepath = ""  
    File.join(basepath, code_shape_match[:filepath])
  end
  
  def code_shape_match
    @code_shape_match ||= perform_code_shape_match
  end
  
  def perform_code_shape_match
	raise "Not a code shape" unless code_shape?
	  
	filename_pattern = /.+?/
	numbers_pattern = /\[(\d+|\d+-|-\d+|\d+-\d+)\]/
    pattern = /#{INCLUDE_COMMAND}=(#{filename_pattern})(#{numbers_pattern})?$/
	  
	match = pattern.match(@shape.text.strip)
    
    {
      :filepath => match[1],
      :slide_range => match[3]
    }
  end
  
  def read_text filepath
    text = ""
	begin
	  open(filepath) {|f| f.each_line {|line| text += line }}
	  text
	rescue
	  raise "Cannot read Input Source '#{filepath}' from Slide #{slide.number}"
	end
  end
  
  def create_parser filepath, text
    case (filepath.split('.').last)
	  when 'as', 'java', 'cs'
		CodeParser.new(filepath, text)
	  when 'xml'
		XMLParser.new(filepath, text)
      else
         raise "Not valid file format for #{filepath}"
      end
   end
  
  def calculate_slide_numbers max_slide_number
	  range_string = code_shape_match[:slide_range]
	  if range_string.nil?
		0..max_slide_number
	  elsif range_string =~ /^(\d+)-$/
		$1.to_i..max_slide_number
	  elsif range_string =~ /^-(\d+)$/
		0..$1.to_i
	  elsif range_string =~ /^(\d+)-(\d+)$/
		$1.to_i..$2.to_i
	  elsif range_string =~ /^\d+$/
		$&.to_i..$&.to_i
	  else
		raise "Error interpreting #{range_string}"
	  end.to_a
	end
end