module Zapata
  class Analyst
    def self.analyze(filename)
      code = CodeParser.parse(filename)
      VarCollector.new(code).result
    end
  end
end
