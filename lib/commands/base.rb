module Command
  class Base
    attr_reader :slide_number

    def initialize slide_number
      @slide_number = slide_number
    end

    def reject other_command, actual_slide_number
      false
    end

    def formattings actual_slide_number, text_range
    end

    def prevent_insert actual_slide_number
      false
    end
	
	def inspect
	  "#{self.class.name}(#{@slide_number})"
	end

    protected
    def before_slide?(actual_slide_number)
      actual_slide_number < @slide_number
    end
    alias :inactive? :before_slide?

    def at_slide?(actual_slide_number)
      actual_slide_number == @slide_number
    end

    def after_slide?(actual_slide_number)
      actual_slide_number > @slide_number
    end

    def active?(actual_slide)
      at_slide?(actual_slide) or after_slide?(actual_slide)
    end

    def overlay(other_slide)
      other_slide.slide_number < @slide_number
    end
  end
end