class TagMatch

  OPEN = "["
  CLOSE = "]"

  attr_reader :command, :pre_text, :post_text
  
  def initialize command, direction, pre_text, post_text
    raise "invalid direction" unless direction == OPEN or direction == CLOSE
    @command, @direction = command, direction
    @pre_text, @post_text = pre_text, post_text
  end
  
  def open_tag?
    @direction == OPEN
  end

  def close_tag?
    @direction == CLOSE
  end
end