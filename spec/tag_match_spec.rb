$:.unshift File.dirname($0)
require 'lib/loader'

describe TagMatch do

  it "should have an open tag" do
    tag_match = TagMatch.new(:command, TagMatch::OPEN, :pre, :post)
    
    tag_match.should be_open_tag
    tag_match.should_not be_close_tag
    tag_match.command.should eql(:command)
    tag_match.pre_text.should eql(:pre)
    tag_match.post_text.should eql(:post)
  end
  
  it "should have an close tag" do
    tag_match = TagMatch.new(:command, TagMatch::CLOSE, :pre, :post)
    
    tag_match.should_not be_open_tag
    tag_match.should be_close_tag
    tag_match.command.should eql(:command)
    tag_match.pre_text.should eql(:pre)
    tag_match.post_text.should eql(:post)
  end
  
  it "should throw an error on invalid direction" do
    lambda{
      tag_match = TagMatch.new(:command, :smth, :pre, :post)
    }.should raise_error
  end

end