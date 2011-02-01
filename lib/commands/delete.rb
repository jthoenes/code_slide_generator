module Command
  class Delete < Base
     def reject other_command, actual_slide_number
      if active?(actual_slide_number) and other_command.class == Add and overlay(other_command)
        return true
      else
        false
      end

    end

    def formattings actual_slide_number
      []
    end

    def prevent_insert actual_slide_number
      active?(actual_slide_number)
    end
  end
end