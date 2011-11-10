class Formatting

  def self.available
    @registry.keys
  end
  
  def self.[](character)
    @registry[character]
  end
  
  def self.start
    @start_command ||= new('~~START~~')
  end
  
  def self.create(character)
    instance = new(character)
	@registry ||= {}
	@registry[character] = instance
	instance
  end
  
  def create_formatting slide_number
    Formatting.new(self, slide_number)
  end
  
  def add_at_slide_formats formats
    @at_slide_formats = @at_slide_formats + formats
  end
  
  def add_from_slide_formats formats
    @from_slide_formats = @from_slide_formats + formats
  end
  
  attr_reader :at_slide_formats, :from_slide_formats
  
  private
  def initialize(character)
    @character = character
    @at_slide_formats = []
	@from_slide_formats = []
  end
  
end

class Formattings

  def initialize list = []
    @list = list
  end
  
  def including slide_number, formattings
    new_list = @list.clone
	formattings.each do |formatting| 
	  new_list[slide_number] ||= []
	  new_list[slide_number] << formatting
	end
	Formattings.new(new_list)
  end
  
  def relevant_formats slide_number
    formats = {}
    formats_until_slide(slide_number) do |format|
	  # later slides formattings will override earlier ones
	  formats[format.type] = format
	end
	formats_at_slide(slide_number) do |format|
	  # formattings for this very slide will override anything else
	  formats[format.type] = format
	end
	
	formats.values
  end
  
  private
  def formats_until_slide(slide_number, &block)
    @list[0..slide_number].each do |formattings|
	  formattings.each do |formatting|
	    formatting.from_slide_formats.each(&block)
      end unless formattings.nil?
    end
  end
  
  def formats_at_slide(slide_number, &block)
    @list[slide_number].each do |formatting|
	   formatting.at_slide_formats.each(&block)
	end unless @list[slide_number].nil?
  end
  
  

end