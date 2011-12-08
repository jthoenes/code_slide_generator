module FormattingDSL  

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
  
end