dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/protometagrammar_spec_helper"

describe "The subset of the metagrammar rooted at the sequence rule" do
  include ProtometagrammarSpecContextHelper
  
  before do
    @root = :sequence
  end

  it "parses a series of space-separated terminals and nonterminals as a sequence" do
    with_protometagrammar(@root) do |parser|
      syntax_node = parser.parse('"terminal" nonterminal1 nonterminal2')
      syntax_node.should be_success  

      grammar = Grammar.new
      sequence = syntax_node.value(grammar)
      sequence.should be_an_instance_of(Sequence)
      sequence.elements[0].should be_an_instance_of(TerminalSymbol)
      sequence.elements[0].prefix.should == "terminal"
      sequence.elements[1].should be_an_instance_of(NonterminalSymbol)
      sequence.elements[1].name.should == :nonterminal1
      sequence.elements[2].should be_an_instance_of(NonterminalSymbol)
      sequence.elements[2].name.should == :nonterminal2
    end
  end
  
  it "parses a series of space-separated non-terminals as a sequence" do
    with_protometagrammar(@root) do |parser|
      syntax_node = parser.parse('a b c')

      grammar = Grammar.new
      sequence = syntax_node.value(grammar)
      sequence.should be_an_instance_of(Sequence)
    end
  end
  
  it "node class evaluates a block following a sequence in the parsing expression for that sequence" do
    with_protometagrammar(@root) do |parser|
      result = parser.parse("a b c {\n  def a_method\n  end\n}")
      result.should be_success
    
      grammar = Grammar.new
      sequence = result.value(grammar)
      sequence.should be_an_instance_of(Sequence)
      sequence.node_class.instance_methods.should include('a_method')      
    end
  end
  
  it "binds trailing blocks more tightly to terminal symbols than sequences" do
    with_protometagrammar(@root) do |parser|
      result = parser.parse("a b 'c' {\n  def a_method\n  end\n}")
      result.should be_success
    
      grammar = Grammar.new
      sequence = result.value(grammar)
      sequence.should be_an_instance_of(Sequence)
      sequence.node_class.instance_methods.should_not include('a_method')
      sequence.elements[2].node_class.instance_methods.should include('a_method')      
    end
  end
end