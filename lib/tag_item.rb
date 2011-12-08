class TagItem

  attr_reader :parent, :line_number, :children, :slide_number, :formattings

  def initialize parent, slide_number, formattings, line_number
    @parent, @slide_number, @line_number = parent, slide_number, line_number
	  @formattings = formattings
    @children = []
  end

  def add_child child
    @children << child
  end

  def matching slide_number, formattings
    slide_number == @slide_number and @formattings == formattings
  end

  def max_slide_number
     ([@slide_number] + @children.map{|item| item.max_slide_number}).max
  end


  def formattable_texts formattings
    @children.map{|item| item.formattable_texts(formattings.including(slide_number, @formattings))}.flatten
  end
  
  # Reporting
  def source
    "#{@slide_number}#{@formattings.map(&:character).join}"
  end
  
  def print_tree
    puts "line #{@line_number}: #{source} => {#{@children.map(&:source).join(',')}}"
    @children.each(&:print_tree)
  end
  
  def inspect
    "TagItem<line:#{@line_number},#{@formattings.inspect},children:#{@children.inspect}>"
  end

end