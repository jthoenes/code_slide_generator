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
	  @shape.Fill.ForeColor
	end
	
	def prepare!
	  text_range.clear!
	end
	
	def text_range
	  @text_range ||= TextRange.new(self, @shape.TextFrame.TextRange)
	end
  end
  
  class Shape
    INCLUDE_COMMAND = "INCLUDE_SOURCE".freeze
	
    def code_shape?
	  text_field? and text.strip =~ /#{INCLUDE_COMMAND}=(.+)$/
	end
	
	def formatter(basepath)
	  filepath = code_filepath(basepath)
	
	  text = read_text(filepath)	
	  parser = create_parser(filepath, text)
		
	  max_slide_number, formattable_texts = parser.parse
		
	  slide_range = calculate_range(max_slide_number)
	  
	  ShapeFormatter.new(self, formattable_texts, slide_range)
	end
	
	def code_filepath basepath = ""  
      File.join(basepath, code_shape_match[1])
	end
	
	def calculate_range max_slide_number
	  range_string = code_shape_match[3]
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
	  end
	end
	
	private
	def code_shape_match
	  raise "Not a code shape" unless code_shape?
	  
	  filename_pattern = /.+?/
	  numbers_pattern = /\[(\d+|\d+-|-\d+|\d+-\d+)\]/
      pattern = /#{INCLUDE_COMMAND}=(#{filename_pattern})(#{numbers_pattern})?$/
	  
	  pattern.match(text.strip)
	end
	public
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
	
  end
end