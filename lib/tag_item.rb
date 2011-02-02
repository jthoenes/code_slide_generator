class TagItem

  attr_reader :parent, :line_number, :children, :slide_number

  def initialize parent, slide_number, command_type, line_number
    @parent, @slide_number, @command, @line_number = parent, slide_number, command_type.new(slide_number), line_number
    @children = []
  end

  def add_child child
    @children << child
  end

  def matching slide_number, command_type
    slide_number == @slide_number and command_type == @command.class
  end

  def close
  end

  def max_slide_number
     ([@slide_number] + @children.map{|item| item.max_slide_number}).max
  end
  
  def command_type
    @command.class
  end

  def formattable_texts commands
    commands = [commands, @command].flatten
    @children.map{|item| item.formattable_texts(commands)}.flatten
  end
  
  def inspect
    "TagItem<line:#{@line_number},#{@command.inspect},children:#{@children.inspect}>"
  end

end