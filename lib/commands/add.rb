module Command
  class Add < Base

    def reject other_command, actual_slide_number
      if active?(actual_slide_number) and other_command.class == Delete and overlay(other_command)
        return true
      else
        false
      end

    end

    def formattings actual_slide_number
      if at_slide?(actual_slide_number)
        [:bold]
      else
        []
      end
    end

    def prevent_insert actual_slide_number
      before_slide?(actual_slide_number)
    end
  end
end