class Parser

  TAB_WIDTH = 2

  COMMANDS = {
      'r' => Command::Red,
      'b' => Command::Bold,
      '<' => Command::White,
      '>' => Command::Unwhite,
      '+' => Command::Add,
      '-' => Command::Delete
  }.freeze

  OPEN = "["
  CLOSE = "]"
  DIRECTIONS = [OPEN, CLOSE].freeze

  SLIDE_NUMBER_PATTERN = /\d+/
  COMMANDS_PATTERN = /(#{COMMANDS.keys.map { |c| Regexp.escape(c) }.join('|')})/.freeze
  DIRECTION_PATTERN = /(#{DIRECTIONS.map { |d| Regexp.escape(d) }.join('|')})/.freeze

  TAG_PATTERN = /((#{SLIDE_NUMBER_PATTERN})(#{COMMANDS_PATTERN})(#{DIRECTION_PATTERN}))/.freeze


  def initialize text
    @text = clean_up_text(text)
  end

  def clean_up_text text
    text.gsub(/\r+\n/, "\n").gsub(/\t/, " "*TAB_WIDTH)
  end

  def parse
    tag_item = TagItem.new nil, 0, Command::Start, 0

    @lines = @text.split(/\n/)
    @lines.each_with_index do |line, line_number|
      line_number += 1
      work_line = line
      loop do
        match = tag_pattern.match(work_line)
        break if match.nil?
        work_line = match.post_match

        tag_item.add_child(create_text_item(match.pre_match))

        if is_open? match
          tag_item = create_tag_item(tag_item, line_number, match)
        elsif is_close? match
           tag_item = close_tag(tag_item, match)
        else
          raise "Invalid tag in line #{line_number}"
        end

      end
      tag_item.add_child(create_text_item(work_line))
      tag_item.add_child(create_text_item("\n"))
    end

    return tag_item.max_slide_number, tag_item.formattable_texts([])
  end

  private
  def is_open? match
    match[5] == OPEN
  end

  def is_close? match
    match[5] == CLOSE
  end

  def create_text_item text
    TextItem.new text
  end

  def create_tag_item parent, line_number, match
    slide_number, command = tag_info_from_match(match)
    tag_item = TagItem.new(parent, slide_number, command, line_number)
    parent.add_child(tag_item)

    tag_item
  end

  def close_tag tag_item, match
    if tag_item.matching(*tag_info_from_match(match))
      tag_item.close
      tag_item.parent
    else
      raise "No end tag for slide #{match.slide_number}, #{match.command} in line #{match.line_number}"
    end
  end

  def tag_info_from_match match
    return match[2].to_i, COMMANDS[match[3]]
  end
end
