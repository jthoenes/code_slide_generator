$:.unshift File.dirname($0) + '/..'
require 'lib/loader'


def create_tree hash
  create_node(RootNode.new, hash)
end

def create_node node, item
  if item.is_a?(Hash)
    item.each do |command, items|
      child_node = CommandNode.new(node, command, 0)
      node.add_child(child_node)
      create_node(child_node, items)
    end
  else
    child_node = TextNode.new(item)
    node.add_child(child_node)
  end
  node
end

class FormattableText
  attr_accessor :text, :formattings
end

class Formattings
  attr_accessor :slide_number, :list
end

describe "tree transversal for formatting" do

  before(:all) do
    @b_f = Formatting.create('a')
    @b_f = Formatting.create('b')
    @b_f = Formatting.create('c')
    @b_f = Formatting.create('d')
  end
  
  after(:all) do
    Formatting.instance_variable_set('@registry', {})
  end
  
  describe " with most simple example" do
  
    before(:all) do
      @root_node = create_tree({'1a' => "A"})
      @ft = @root_node.to_formattable_texts
    end
  
    it "should have one item" do
      @ft.should have(1).item
    end
    
    it "should have A text" do
      @ft[0].text.should eql("A")
    end
    
    it "should have 1a formatting" do
      @ft[0].formattings.list[1].first.should eql(Formatting['a'])
    end
    
  end
  
  describe "with more complex example" do
    
    before(:all) do
      @root_node = create_tree({'5a' => {'3b' => "ONE"}, '6c' => {'5da' => {'0a' => 'TWO'}, '6b' => 'THREE'}})
      @fts = @root_node.to_formattable_texts
    end
    
    it "should have three items" do
      @fts.should have(3).items
    end
    
    describe "on formattable_text 'ONE'" do
      before(:all) do
        @ft = @fts[0]
      end
    
      it "should have text 'ONE'" do
        @ft.text.should eql('ONE')
      end
      
      it "should have 3b formatting" do
        @ft.formattings.list[3].should eql([Formatting['b']])
      end
      
      it "should have 5a formatting" do
        @ft.formattings.list[5].should eql([Formatting['a']])
      end
      
      it "should have 6 formatting items" do
        @ft.formattings.list.should have(6).items
      end
    end
    
    describe "on formattable_text 'TWO'" do
      before(:all) do
        @ft = @fts[2] # hashes are unordered
      end
    
      it "should have text 'TWO'" do
        @ft.text.should eql('TWO')
      end
      
      it "should have 0a formatting" do
        @ft.formattings.list[0].should eql([Formatting.start, Formatting['a']])
      end      
      
      it "should have 5da formatting" do
        @ft.formattings.list[5].should eql([Formatting['d'],Formatting['a']])
      end
      
      it "should have 6c formatting" do
        @ft.formattings.list[6].should eql([Formatting['c']])
      end
           
      it "should have 7 formatting items" do
        @ft.formattings.list.should have(7).items
      end
    end
    
    describe "on formattable_text 'THREE'" do
      before(:all) do
        @ft = @fts[1] # hashes are unordered
      end
    
      it "should have text 'THREE'" do
        @ft.text.should eql('THREE')
      end
      
      it "should have 6cd formatting" do
        @ft.formattings.list[6].should eql([Formatting['c'], Formatting['b']])
      end
        
      it "should have 7 formatting items" do
        @ft.formattings.list.should have(7).items
      end
    end
  end
  
  

end
