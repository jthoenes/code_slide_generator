module Command
  class Bold < Base
    def formattings actual_slide_number, text_range
      if at_slide?(actual_slide_number)
        text_range.bold!
      end
    end
  end
end