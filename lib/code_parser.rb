class CodeParser < Parser
  def tag_pattern
    /#{Regexp.escape('/*')}\s*#{TAG_PATTERN}\s*#{Regexp.escape('*/')}/
  end
end