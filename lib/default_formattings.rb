require 'lib/format'
require 'lib/format_command'

class FormattingParser
  
  def self.handle &block
    instance = new
	instance.instance_eval(&block)
	instance.commands
  end
  
  attr_reader :commands
  
  def initialize
    @commands = []
  end

  def format character, &block
    @commands << FormatHandler.handle(character, &block)
  end
  
  def toggle_formats character_on, character_off, &block
    ToggleFormatHandler.handle(character_on, character_off, &block).each do |command|
	  @commands << command
	end
  end
end

class ToggleFormatHandler

  def self.handle character_on, character_off, &block
    instance = new(character_on, character_off)
	instance.instance_eval(&block)
	instance.commands
  end
  
  attr_reader :commands

  def initialize(character_on, character_off)
    @character_on, @character_off = character_on, character_off
	@commands = []
  end
  
  def on &block
    FormatHandler.new(@character_on).instance_eval(&block)
  end
  
  def off &block
    FormatHandler.new(@character_off).instance_eval(&block)
  end
end

class FormatHandler

  def self.handle character, &block
    instance = new(character)
	instance.instance_eval(&block)
	instance.command
  end
  
  attr_reader :command

  def initialize(character)
    @command = Formatting.create(character)
  end
  
  def at_slide &block
    @command.add_at_slide_formats(FormatExtractor.extract(&block))
  end
  
  def from_slide &block
    @command.add_from_slide_formats(FormatExtractor.extract(&block))
  end
  
end

class FormatExtractor

  def self.extract(&block)
    instance = new
	instance.instance_eval(&block)
	instance.formats
  end
  
  attr_reader :formats
  
  def initialize
    @formats = []
  end

  protected
  def method_missing method, *args
    super unless Format.methods.include?(method.to_s)
	@formats << Format.send(method, *args)
  end
end

def formatting &block
  FormattingParser.handle(&block)
end

formatting do
  
  
  
  format 'b' do
    at_slide { bold }
  end
  
  format 'r' do 
    at_slide { bold; color 0,0,255 }
  end
  
  format 'B' do 
    from_slide { bold }
  end
  
  format 'R' do 
    from_slide { bold; color 0,0,255 }
  end
  
  toggle_formats '>', '<' do
    on do
	  at_slide { bold; color 0,0,0 }
    end
    off do
      from_slide { background_color }
    end
  end

  toggle_formats '+', '-' do
    on do
      from_slide { undelete }
	  at_slide { bold }
	end
	off do
      from_slide { delete }
	end
  end  
  
end