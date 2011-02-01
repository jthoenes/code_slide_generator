module Command
  class White < Base
     def reject other_command, actual_slide_number
      if active?(actual_slide_number) and other_command.class == Unwhite and overlay(other_command)
        return true
      elsif active?(actual_slide_number) and other_command.class == Red and overlay(other_command)
        return true
      else
        false
      end

    end

    def formattings actual_slide_number
      if active?(actual_slide_number)
        [:white]
      else
        []
      end
    end
  end
end