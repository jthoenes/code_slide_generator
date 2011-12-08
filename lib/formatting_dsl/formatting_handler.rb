module FormattingDSL  
  class FormattingHandler
  
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
  
end