require 'lib/format'
require 'lib/format_command'

class FormattingParser
  
  def self.handle &block
    instance = new
	instance.instance_eval(&block)
	instance.commands
  end
  
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
  
  def commands
    @commands
  end
end

class ToggleFormatHandler

  def self.handle character_on, character_off, &block
    instance = new(character_on, character_off)
	instance.instance_eval(&block)
	instance.process_commands
	instance.commands
  end

  def initialize(character_on, character_off)
    @character_on, @character_off = character_on, character_off
  end
  
  def on &block
    @on_command = FormatHandler.handle(@character_on, &block)
  end
  
  def off &block
    @off_command = FormatHandler.handle(@character_off, &block)
  end
  
  def process_commands
    @on_command.add_until_slide_formats(@off_command.from_slide_formats)
	@off_command.add_until_slide_formats(@on_command.from_slide_formats)
  end
  
  def commands
    [@on_command, @off_command]
  end
end

class FormatHandler

  def self.handle character, &block
    instance = new(character)
	instance.instance_eval(&block)
	instance.command
  end

  def initialize(character)
    @command = Formatting.create(character)
  end
  
  def at_slide &block
    @command.add_at_slide_formats(FormatExtractor.extract(&block))
  end
  
  def from_slide &block
    @command.add_from_slide_formats(FormatExtractor.extract(&block))
  end
  
  def command
    @command
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