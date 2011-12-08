class CommandNode

  SLIDE_NUMBER_PATTERN = /\d+/
  def self.pattern
    /(#{SLIDE_NUMBER_PATTERN})((#{Formatting.pattern})+)/
  end

  attr_reader :parent, :line_number, :children, :command, :slide_number, :formattings

  def initialize parent, command, line_number
    @parent, @command, @line_number = parent, command, line_number
    @slide_number, @formattings = parse_command(command)
    @children = []
  end

  def add_child child
    @children << child
  end

  def matching command
    @command == command
  end

  def max_slide_number
     ([@slide_number] + @children.map{|item| item.max_slide_number}).max
  end


  def formattable_texts formattings
    @children.map{|item| item.formattable_texts(formattings.including(slide_number, @formattings))}.flatten
  end
  
  # Reporting
  alias :souce :command
  
  def print_tree
    puts "line #{@line_number}: #{source} => {#{@children.map(&:source).join(',')}}"
    @children.each(&:print_tree)
  end
  
  def inspect
    "Code<line:#{@line_number},command:#{@command},children:#{@children.inspect}>"
  end
  
  private
  def parse_command command
    matchdata = CommandNode.pattern.match(command)
    raise "Parse Error in Parsing Command '#{command}'" if matchdata.nil?    
    return matchdata[1].to_i, matchdata[2].chars.map{|c| Formatting[c]}
  end
end

class RootNode < CommandNode
  include Singleton
  
  def initialize
    @parent, @command, @line_number = nil, '~~ROOT~~', 0
    @slide_number, @formattings = 0, [Formatting.start]
    @children = []
  end
end