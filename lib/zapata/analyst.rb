module Zapata
  class Analyst
    def self.analyze(filename)
      code = CodeParser.parse(filename)
      VarAnalysis.new(code).result
    end
  end
end
