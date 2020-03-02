# frozen_string_literal: true

module Zapata
  class Analyst
    attr_reader :result

    def self.analyze(filename)
      code = Core::Reader.parse(filename)
      analyst = Analyst.new(code)
      result = analyst.result.dup
      analyst.clean
      result
    end

    def initialize(code)
      # class dive
      Diver.search_for(:klass)
      Diver.dive(code)
      # var dive
      Diver.search_for(:var)
      Diver.dive(code)
      # def dive
      Diver.search_for(:def)
      Diver.dive(code)
      # send dive
      Diver.search_for(:send)
      Diver.dive(code)

      @result = DB.all
    end

    def clean
      DB.destroy_all
    end
  end
end
