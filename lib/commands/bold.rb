module Command
  class Bold < Base
    def formattings actual_slide_number
      if at_slide?(actual_slide_number)
        [:bold]
      else
        []
      end
    end
  end
end