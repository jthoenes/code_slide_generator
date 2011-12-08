class Parser

  TAB_WIDTH = 2


  def initialize filename, text
    @filename = filename
    @text = clean_up_text(text)
  end

  def clean_up_text text
    text.gsub(/\r+\n/, "\n").gsub(/\t/, " "*TAB_WIDTH)
  end

  def parse
    root_node = create_ast 
  
	  return root_node.max_slide_number, root_node.formattable_texts(Formattings.new)
  end
  
  protected

  OPEN = "["
  CLOSE = "]"
  DIRECTIONS = [OPEN, CLOSE].freeze

  SLIDE_NUMBER_PATTERN = /\d+/
  
  def tag_pattern
    commands_pattern = /(#{Formatting.available.map { |c| Regexp.escape(c) }.join('|')})+/
    direction_pattern = /(#{DIRECTIONS.map { |d| Regexp.escape(d) }.join('|')})/

    /((#{SLIDE_NUMBER_PATTERN})(#{commands_pattern})(#{direction_pattern}))/  
  end

  private
  def create_ast
    command_node = CommandNode.new nil, 0, [Formatting.start], 0

    @lines = @text.split(/\n/)
    @lines.each_with_index do |line, line_number|
      line_number += 1
      work_line = line
      loop do
        match = tag_pattern.match(work_line)
        if match.nil?
			create_text_node(command_node, work_line)
			break
		end
        work_line = match.post_match
		
		   create_text_node(command_node, match.pre_match)

        if is_open? match
		   command_node = create_command_node(command_node, line_number, match)
        elsif is_close? match
		   command_node = close_node(command_node, match)
        else
          raise "Invalid tag in line #{line_number}"
        end
      end
      create_text_node(command_node, "\n") unless @lines.last == line
    end
	
	  unless command_node.matching(0, [Formatting.start])
		  raise "#{@filename}: No end tag for slide #{command_node.slide_number}, #{command_node.command_type} in line #{command_node.line_number}"
	  end
    
    command_node
  end
  
  def is_open? match
    match[5] == OPEN
  end

  def is_close? match
    match[5] == CLOSE
  end

  def create_text_node command_node, text
    unless text.nil? or text.empty?
      command_node.add_child(TextNode.new(text))
    end
  end

  def create_command_node parent, line_number, match
    slide_number, commands = tag_info_from_match(match)
    command_node = CommandNode.new(parent, slide_number, commands, line_number)
    parent.add_child(command_node)

    command_node
  end

  def close_node command_node, match
    slide_number, commands = tag_info_from_match(match)
    if command_node.matching(slide_number, commands)
      return command_node.parent
    else
      raise "#{@filename}: No end tag for #{command_node.source} in line #{command_node.line_number}"
    end
  end

  def tag_info_from_match match
    return match[2].to_i, match[3].split('').map{|c| Formatting[c]}
  end
end
