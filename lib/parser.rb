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
    tag_item = TagItem.new nil, 0, [Formatting.start], 0

    @lines = @text.split(/\n/)
    @lines.each_with_index do |line, line_number|
      line_number += 1
      work_line = line
      loop do
        match = tag_pattern.match(work_line)
        if match.nil?
			create_text_item(tag_item, work_line)
			break
		end
        work_line = match.post_match
		
		   create_text_item(tag_item, match.pre_match)

        if is_open? match
		   tag_item = create_tag_item(tag_item, line_number, match)
        elsif is_close? match
		   tag_item = close_tag(tag_item, match)
        else
          raise "Invalid tag in line #{line_number}"
        end
      end
      create_text_item(tag_item, "\n") unless @lines.last == line
    end
	
	  unless tag_item.matching(0, [Formatting.start])
		  raise "#{@filename}: No end tag for slide #{tag_item.slide_number}, #{tag_item.command_type} in line #{tag_item.line_number}"
	  end
	
    tag_item.print_tree
  
	  return tag_item.max_slide_number, tag_item.formattable_texts(Formattings.new)
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
  def is_open? match
    match[5] == OPEN
  end

  def is_close? match
    match[5] == CLOSE
  end

  def create_text_item tag_item, text
    unless text.nil? or text.empty?
      tag_item.add_child(TextItem.new(text))
    end
  end

  def create_tag_item parent, line_number, match
    slide_number, commands = tag_info_from_match(match)
    tag_item = TagItem.new(parent, slide_number, commands, line_number)
    parent.add_child(tag_item)

    tag_item
  end

  def close_tag tag_item, match
    slide_number, commands = tag_info_from_match(match)
    if tag_item.matching(slide_number, commands)
      return tag_item.parent
    else
      raise "#{@filename}: No end tag for #{tag_item.source} in line #{tag_item.line_number}"
    end
  end

  def tag_info_from_match match
    return match[2].to_i, match[3].split('').map{|c| Formatting[c]}
  end
end
