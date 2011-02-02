module Command
  class Red < Base
    def formattings actual_slide_number, text_range
      if at_slide?(actual_slide_number)
        text_range.red!
		text_range.bold!
      end
    end
  end
end