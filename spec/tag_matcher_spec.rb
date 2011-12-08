$:.unshift File.dirname($0)
require 'lib/loader'

describe TagMatch do

  before(:all) do
    Formatting.create('a')
    Formatting.create('b')
    Formatting.create('c')
    Formatting.create('d')
  
    @tag_matcher = TagMatcher.new('=>', '<=')
  end
  
  after(:all) do
    Formatting.instance_variable_set('@registry', {})
  end

  it "should match 'ONE=>1a[<=TWO=>2b[<=THREE=>3c]<=FOUR=>4d]<=FIVE'" do
    tag_match = @tag_matcher.match("ONE=>1a[<=TWO=>2b[<=THREE=>3c]<=FOUR=>4d]<=FIVE")
    
    tag_match.should be_open_tag
    tag_match.command.should eql('1a')
    tag_match.pre_text.should eql('ONE')
    tag_match.post_text.should eql('TWO=>2b[<=THREE=>3c]<=FOUR=>4d]<=FIVE')
  end
  
  it "should match 'TWO=>2b[<=THREE=>3c]<=FOUR=>4d]<=FIVE'" do
    tag_match = @tag_matcher.match("TWO=>2b[<=THREE=>3c]<=FOUR=>4d]<=FIVE")
    
    tag_match.should be_open_tag
    tag_match.command.should eql('2b')
    tag_match.pre_text.should eql('TWO')
    tag_match.post_text.should eql('THREE=>3c]<=FOUR=>4d]<=FIVE')
  end
  
  it "should match 'THREE=>3c]<=FOUR=>4d]<=FIVE'" do
    tag_match = @tag_matcher.match("THREE=>3c]<=FOUR=>4d]<=FIVE")
    
    tag_match.should be_close_tag
    tag_match.command.should eql('3c')
    tag_match.pre_text.should eql('THREE')
    tag_match.post_text.should eql('FOUR=>4d]<=FIVE')
  end
  
  it "should match 'FOUR=>4d]<=FIVE'" do
    tag_match = @tag_matcher.match("FOUR=>4d]<=FIVE")
    
    tag_match.should be_close_tag
    tag_match.command.should eql('4d')
    tag_match.pre_text.should eql('FOUR')
    tag_match.post_text.should eql('FIVE')
  end

end