module Zapata
  module Primitive
    class Ivar < Basic
      def value
        binding.pry
        Evaluation.new(@body.to_a.first.to_s)
      end
    end
  end
end
