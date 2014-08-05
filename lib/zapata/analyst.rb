module Zapata
  class Analyst
    def self.analyze(filename)
      code = CodeReader.parse(filename)
      var_analysis = VarAnalysis.new(code)
      result = var_analysis.result
      var_analysis.clean
      result
    end
  end
end
