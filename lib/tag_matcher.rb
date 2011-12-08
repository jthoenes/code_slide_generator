class TagMatcher
  

  def initialize pre_pattern, post_pattern
    @pre_pattern, @post_pattern = pre_pattern, post_pattern
  end
  
  def match  text
    if match = tag_pattern.match(text)
      command, direction = match[2], match[6]
      pre_text, post_text = match.pre_match, match.post_match
      
      TagMatch.new(command, direction, pre_text, post_text)
    else
      nil
    end
  end  
  
  
  private  
  def tag_pattern
    @tag_pattern ||= assemble_tag_pattern
  end
  
  def assemble_tag_pattern
   direction_pattern = /(#{Regexp.escape(TagMatch::OPEN)}|#{Regexp.escape(TagMatch::CLOSE)})/
   command_pattern = CommandNode.pattern
   
   /#{@pre_pattern}\s*((#{command_pattern})(#{direction_pattern}))\s*#{@post_pattern}/ 
  end
end