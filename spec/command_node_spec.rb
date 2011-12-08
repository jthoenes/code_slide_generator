$:.unshift File.dirname($0)
require 'lib/loader'

describe CommandNode do

  before(:all) do
    @b_f = Formatting.create('b')
    @plus_f = Formatting.create('+')
    @minus_f = Formatting.create('-')
  end
    
  after(:all) do
    Formatting.instance_variable_set('@registry', {})
  end
    
  describe "basic initialization" do
  
    before(:all) do
      @command_node = CommandNode.new(:a, '3b', 0)
    end
    
    it "should simply assign the parent" do
      @command_node.parent.should be(:a)
    end
    
    it "should simply assign the command" do
      @command_node.command.should eql('3b')
    end
    
    it "should simply assing the line number" do
      @command_node.line_number.should eql(0)
    end
    
    it "should create an empty childrens list" do
      @command_node.children.should be_empty
    end
  
  end

  describe "command parsing" do
  
    it "should get the slide 3 and formatting b from 3b" do
      command_node = CommandNode.new(nil, '3b', 0)
      
      command_node.command.should eql('3b')
      command_node.slide_number.should eql(3)
      command_node.formattings.should eql([@b_f])
    end
    
    it "should get the slide 10 and formatting + from 10+" do
      command_node = CommandNode.new(nil, '10+', 0)
      
      command_node.command.should eql('10+')
      command_node.slide_number.should eql(10)
      command_node.formattings.should eql([@plus_f])
    end
    
    it "should get the slide 999 and formatting - from 999-" do
      command_node = CommandNode.new(nil, '999-', 0)
      
      command_node.command.should eql('999-')
      command_node.slide_number.should eql(999)
      command_node.formattings.should eql([@minus_f])
    end
    
    it "should get the slide 7 and formattings +,b,-,+ from 7+b-+" do
      command_node = CommandNode.new(nil, '7+b-+', 0)
      
      command_node.command.should eql('7+b-+')
      command_node.slide_number.should eql(7)
      command_node.formattings.should eql([@plus_f, @b_f, @minus_f, @plus_f])
    end
  
  end

end