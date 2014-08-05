module Zapata
  class VarAnalysis
    attr_reader :result

    def initialize(code)
      # var dive
      CodeDiver.new(:var).dive(code)
      # def dive
      CodeDiver.new(:def).dive(code)
      # send dive
      CodeDiver.new(:send).dive(code)

      @result = Zapata::AssignmentRecord.all.dup
    end

    def get
      binding.pry
    end

    def clean
      Zapata::AssignmentRecord.destroy_all
    end
  end
end
