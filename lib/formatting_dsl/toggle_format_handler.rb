module FormattingDSL  

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
  
end