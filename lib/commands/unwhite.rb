module Command
  class Unwhite < Base
    def reject other_command, actual_slide_number
      if inactive?(actual_slide_number) and other_command.class == White and overlay(other_command)
        return true
      elsif inactive?(actual_slide_number) and other_command.class == Red and overlay(other_command)
        return true
      else
        false
      end

    end

    def formattings actual_slide_number, text_range
      if inactive?(actual_slide_number)
		text_range.white!
      end
      if at_slide?(actual_slide_number)
        text_range.bold!
      end
    end
  end
end