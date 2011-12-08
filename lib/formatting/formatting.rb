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
  
  def self.pattern
    /#{available.map{ |c| Regexp.escape(c) }.join('|')}/
  end
  
  def add_at_slide_formats formats
    @at_slide_formats = @at_slide_formats + formats
  end
  
  def add_from_slide_formats formats
    @from_slide_formats = @from_slide_formats + formats
  end
  
  def add_until_slide_formats formats
    @until_slide_formats = @until_slide_formats + formats
  end
  
  attr_reader :character, :at_slide_formats, :from_slide_formats, :until_slide_formats
  
  private
  def initialize(character)
    @character = character
    @at_slide_formats = []
	  @from_slide_formats = []
	  @until_slide_formats = []
  end
  
end