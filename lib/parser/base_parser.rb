class BaseParser

  TAB_WIDTH = 2

  def initialize filename, text
    @filename = filename
    @text = clean_up_text(text)
    @tag_matcher = TagMatcher.new(pre_pattern, post_pattern)
  end

  def parse
    command_node = RootNode.instance

    lines = @text.split(/\n/)
    lines.each_with_index do |line, index|
      command_node = parse_line(command_node, line, index + 1, lines.last == line)
    end
  
    unless command_node == RootNode.instance
      raise "#{@filename}: No end tag for slide #{command_node.slide_number}, #{command_node.command_type} in line #{command_node.line_number}"
    end
    
    command_node
  end

  private
  def clean_up_text text
    text.gsub(/\r+\n/, "\n").gsub(/\t/, " "*TAB_WIDTH)
  end
  
  def parse_line command_node, line, line_number, last_line
    text_to_parse = line
      
    loop do
      # no command is matched => stop
      unless match = tag_match(text_to_parse)
        create_text_node(command_node, text_to_parse)
        break
      end
      
      # before matched command => create text node
      create_text_node(command_node, match.pre_text)

      # handle matched command => create command node
      if match.open_tag?
        command_node = create_command_node(command_node, line_number, match.command)
      elsif match.close_tag? 
        command_node = close_node(command_node, match.command)
      else
        raise "Invalid tag in line #{line_number}"
      end
      
      # After matched command => process further
      text_to_parse = match.post_text
    end
    
    # Add linebreak again (except on last line)
    create_text_node(command_node, "\n") unless last_line
    
    command_node
  end
  
  def tag_match text
    @tag_matcher.match(text)
  end

  def create_text_node command_node, text
    unless text.nil? or text.empty?
      command_node.add_child(TextNode.new(text))
    end
  end

  def create_command_node parent, line_number, command
    command_node = CommandNode.new(parent, command, line_number)
    parent.add_child(command_node)

    command_node
  end

  def close_node command_node, command
    if command_node.matching(command)
      return command_node.parent
    else
      raise "#{@filename}: No end tag for #{command_node.source} in line #{command_node.line_number}"
    end
  end
end
