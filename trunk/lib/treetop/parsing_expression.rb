module Treetop
  class ParsingExpression
    def zero_or_more
      ZeroOrMore.new(self)
    end
  end
  
  class AtomicParsingExpression < ParsingExpression
  end
  
  class CompositeParsingExpression < ParsingExpression
  end
end