dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/protometagrammar_spec_helper"

describe "The subset of the Protometagrammar rooted at the grammar rule" do
  include ProtometagrammarSpecContextHelper

  before do
    @root = :grammar
    @metagrammar = Protometagrammar.new
    parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:grammar)
  end
  
  it "parses a named empty grammar" do
    with_protometagrammar(@root) do |parser|
      result = parser.parse("grammar Foo end")
      value = result.value
      value.should be_instance_of(Grammar)
      value.name.should == :Foo
    end
  end

  it "parses an anonymous empty grammar" do
    with_protometagrammar(@root) do |parser|
      result = parser.parse("grammar end")
      result.value.should be_instance_of(Grammar)
    end
  end

  it "parses a grammar with one rule" do
    with_protometagrammar(@root) do |parser|
      input = 
      %{grammar
          rule foo
            bar
          end
        end}
      result = parser.parse(input)
      result.should be_success
      grammar = result.value
      grammar.should be_instance_of(Grammar)
    
      grammar.get_parsing_expression(grammar.nonterminal_symbol(:foo)).should be_an_instance_of(NonterminalSymbol)
    end
  end
  
  it "parses a grammar with two rules" do
    with_protometagrammar(@root) do |parser|
      input = 
      %{grammar
          rule foo
            bar
          end
        
          rule baz
            bop
          end
        end}
      result = parser.parse(input)
      result.should be_success
    
      grammar = result.value
      grammar.should be_instance_of(Grammar)
    
      grammar.get_parsing_expression(grammar.nonterminal_symbol(:foo)).should be_an_instance_of(NonterminalSymbol)
      grammar.get_parsing_expression(grammar.nonterminal_symbol(:baz)).should be_an_instance_of(NonterminalSymbol)
    end
  end
end
