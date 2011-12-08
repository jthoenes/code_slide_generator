class CodeParser < Parser
  def tag_pattern
    /#{Regexp.escape('/*')}\s*#{super}\s*#{Regexp.escape('*/')}/
  end
end