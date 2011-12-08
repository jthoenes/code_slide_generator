class XMLParser < BaseParser
  def pre_pattern
    /#{Regexp.escape('<!--')}/
  end
  
  def post_pattern
    /#{Regexp.escape('-->')}/
  end
end