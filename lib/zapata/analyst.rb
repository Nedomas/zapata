module Zapata
  class Analyst
    def self.analyze(filename)
      code = CodeReader.parse(filename)
      VarAnalysis.new(code).result
    end
  end
end
