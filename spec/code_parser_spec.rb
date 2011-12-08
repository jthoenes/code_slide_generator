require 'lib/rgb'
require 'lib/format'
require 'lib/formatting'
require 'lib/formattings'

require 'lib/parser'
require 'lib/code_parser'
require 'lib/xml_parser'
require 'lib/tag_item'
require 'lib/text_item'
require 'lib/formattable_text'
require 'lib/shape_formatter'

class Parser
  public :create_ast
end

describe CodeParser do 
  
  describe "reference example" do
    REFERENCE_EXAMPLE="/* 5-[ *//* 3b[ */ONE/* 3b]*//*5-] *//* 6-[ *//* 5+[ *//* 0-[ */TWO/* 0-] *//* 5+] *//* 6-] *//* 6+[ */THREE/* 6+] */"
    
    before(:all) do
      @b_format = Formatting.create('b')
      @plus_format = Formatting.create('+')
      @minus_format = Formatting.create('-')
      
      @root = CodeParser.new("spec-non-file", REFERENCE_EXAMPLE).create_ast
    end
  
    it "root tag item" do
      @root.parent.should be_nil
      @root.line_number.should eql(0)
      @root.formattings.should eql([Formatting.start])
      @root.slide_number.should eql(0)
      @root.children.should have(3).items
    end
    
    it "minus 5 tag" do 
      @tag = @root.children[0]
      
      @tag.parent.should be(@root)
      @tag.line_number.should eql(1)
      @tag.slide_number.should eql(5)
      @tag.formattings.should eql([@minus_format])
      @tag.children.should have(1).item
    end
    
    it "minus 6 tag" do
      @tag = @root.children[1]
      
      @tag.parent.should be(@root)
      @tag.line_number.should eql(1)
      @tag.slide_number.should eql(6)
      @tag.formattings.should eql([@minus_format])
      @tag.children.should have(1).item
    end
    
    it "plus 6 tag" do
      @tag = @root.children[2]
      
      @tag.parent.should be(@root)
      @tag.line_number.should eql(1)
      @tag.slide_number.should eql(6)
      @tag.formattings.should eql([@plus_format])
      @tag.children.should have(1).item
    end
    
    it "b 3 tag" do 
      @tag = @root.children[0].children[0]
      
      @tag.parent.should be(@root.children[0])
      @tag.line_number.should eql(1)
      @tag.slide_number.should eql(3)
      @tag.formattings.should eql([@b_format])
      @tag.children.should have(1).item
    end
    
    it "plus 5 tag" do
      @tag = @root.children[1].children[0]
      
      @tag.parent.should be(@root.children[1])
      @tag.line_number.should eql(1)
      @tag.slide_number.should eql(5)
      @tag.formattings.should eql([@plus_format])
      @tag.children.should have(1).item
    end
    
    it "minus 0 tag" do
      @tag = @root.children[1].children[0].children[0]
      
      @tag.parent.should be(@root.children[1].children[0])
      @tag.line_number.should eql(1)
      @tag.slide_number.should eql(0)
      @tag.formattings.should eql([@minus_format])
      @tag.children.should have(1).item
    end
    
    it "ONE text" do
      @text = @root.children[0].children[0].children[0]
      
      @text.text.should eql("ONE")
    end
    
    it "TWO text" do
      @text = @root.children[1].children[0].children[0].children[0]
      
      @text.text.should eql("TWO")
    end
    
    it "THREE text" do
      @text = @root.children[2].children[0]
      
      @text.text.should eql("THREE")
    end
  end
  
  
end