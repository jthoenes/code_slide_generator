$:.unshift File.dirname($0) + '/..'
require 'lib/loader'

class Parser
  public :create_ast
end

describe CodeParser do 
  
  describe "reference example" do
    REFERENCE_EXAMPLE="/* 5-[ *//* 3b[ */ONE/* 3b]*//*5-] *//* 6-[ *//* 5+[ *//* 0-[ */TWO/* 0-] *//* 5+] *//* 6-] *//* 6+[ */THREE/* 6+] */"
    
    before(:all) do
      Formatting.create('b')
      Formatting.create('+')
      Formatting.create('-')
      
      @root = CodeParser.new("spec-non-file", REFERENCE_EXAMPLE).create_ast
    end
  
    it "root tag item" do
      @root.should eql(RootNode.instance)
      @root.children.should have(3).items
    end
    
    it "minus 5 tag" do 
      @tag = @root.children[0]
      
      @tag.parent.should be(@root)
      @tag.line_number.should eql(1)
      @tag.command.should eql('5-')
      @tag.children.should have(1).item
    end
    
    it "minus 6 tag" do
      @tag = @root.children[1]
      
      @tag.parent.should be(@root)
      @tag.line_number.should eql(1)
      @tag.command.should eql('6-')
      @tag.children.should have(1).item
    end
    
    it "plus 6 tag" do
      @tag = @root.children[2]
      
      @tag.parent.should be(@root)
      @tag.line_number.should eql(1)
      @tag.command.should eql('6+')
      @tag.children.should have(1).item
    end
    
    it "b 3 tag" do 
      @tag = @root.children[0].children[0]
      
      @tag.parent.should be(@root.children[0])
      @tag.line_number.should eql(1)
      @tag.command.should eql('3b')
      @tag.children.should have(1).item
    end
    
    it "plus 5 tag" do
      @tag = @root.children[1].children[0]
      
      @tag.parent.should be(@root.children[1])
      @tag.line_number.should eql(1)
      @tag.command.should eql('5+')
      @tag.children.should have(1).item
    end
    
    it "minus 0 tag" do
      @tag = @root.children[1].children[0].children[0]
      
      @tag.parent.should be(@root.children[1].children[0])
      @tag.line_number.should eql(1)
      @tag.command.should eql('0-')
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