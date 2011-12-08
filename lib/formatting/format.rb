class Format
  
  class << self
    
	def bold
      SetFormat.new(:bold=, true)
    end
    
	def unbold
      SetFormat.new(:bold=, false)
    end
	
	def underline
	  SetFormat.new(:underline=, true)
	end
	
	def no_underline
	  SetFormat.new(:underline=, true)
	end
	
	def italic
	  SetFormat.new(:italic=, true)
	end
	
	def non_italic
	  SetFormat.new(:italic=, false)
	end
	
	def color red, green, blue
	  SetFormat.new(:color=, RGB.new(red, green, blue))
	end
	
	def delete
	  DeleteFormat.new(true)
	end
	
	def undelete
	  DeleteFormat.new(false)
	end
	
	def foreground_color
	  NamedColorFormat.new(:foreground_color)
	end
	
	def background_color
	  NamedColorFormat.new(:background_color)
	end
	
	def start
	  NullCommand.new(:start)
	end
	
  end
  
  attr_reader :type
  
  def apply text_range
    raise "please override"
  end
  
  def delete?
    false
  end
end

class NullCommand < Format
  def initialize type
    @type = type
  end
  
  def apply *args
  end
end

class NamedColorFormat < Format
  
  def initialize named_color
    @type = :color
	@named_color = named_color
  end
  
  def apply text_range
    color = text_range.send(@named_color)
    text_range.send(:color=, color);
  end

end

class SetFormat < Format

  def initialize type, value
    @type, @value = type, value
  end
  
  def apply text_range
    text_range.send(type, @value);
  end
  
  private
  def method
    @method ||= "#{type}=".to_sym
  end
end

class DeleteFormat < Format

  def initialize active
    @type = :delete
	@active = active
  end
  
  def apply text_range
  end
  
  def delete?
    @active
  end
  
end