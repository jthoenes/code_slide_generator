module FormattingDSL  

  class FormatHandler

    def self.handle character, &block
      instance = new(character)
    instance.instance_eval(&block)
    instance.command
    end

    def initialize(character)
      @command = ::Formatting.create(character)
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
  
end