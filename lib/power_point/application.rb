module PowerPoint
  class Application
    def initialize
      @ppt = WIN32OLE.new('PowerPoint.Application')
    end
    
    def current_presentation
      Presentation.new @ppt.ActivePresentation
    end
  end
end