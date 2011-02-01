module Command
  class Red < Base
    def formattings actual_slide_number
      if at_slide?(actual_slide_number)
        [:red]
      else
        []
      end
    end
  end
end