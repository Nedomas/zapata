module Zapata
  class Analyst
    attr_reader :result

    def self.analyze(filename)
      code = CodeReader.parse(filename)
      analyst = Analyst.new(code)
      result = analyst.result.dup
      analyst.clean
      result
    end

    def initialize(code)
      # class dive
      CodeDiver.new(:klass).dive(code)
      # var dive
      CodeDiver.new(:var).dive(code)
      # def dive
      CodeDiver.new(:def).dive(code)
      # send dive
      CodeDiver.new(:send).dive(code)

      @result = Zapata::AssignmentRecord.all
    end

    def clean
      Zapata::AssignmentRecord.destroy_all
    end
  end
end
