class TagItem

  attr_reader :parent, :line_number, :children, :slide_number

  def initialize parent, slide_number, command_types, line_number
    @parent, @slide_number, @line_number = parent, slide_number, line_number
	@commands = command_types.map{|command_type| command_type.new(slide_number)}
    @children = []
  end

  def add_child child
    @children << child
  end

  def matching slide_number, command_types
    slide_number == @slide_number and command_types == command_types
  end

  def max_slide_number
     ([@slide_number] + @children.map{|item| item.max_slide_number}).max
  end
  


  def formattable_texts commands
    commands = [commands, @commands].flatten
    @children.map{|item| item.formattable_texts(commands)}.flatten
  end
  
  def inspect
    "TagItem<line:#{@line_number},#{@commands.inspect},children:#{@children.inspect}>"
  end
  
  def command_types
    @commands.map{|command| command.class}
  end

end