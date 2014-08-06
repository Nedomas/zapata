module Zapata
  class Eval
    def initialize(code)
      @code = code
    end

    def value(*)
      binding.pry
    end

    def to_s
      @code
    end
  end
end
