module Zapata
  class VarAnalysis
    attr_reader :result

    def initialize(code)
      diver = CodeDiver.new(code)
      diver.scan_variables
      @result = diver.result
    end
  end
end
