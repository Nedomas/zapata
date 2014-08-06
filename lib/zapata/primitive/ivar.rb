module Zapata
  module Primitive
    class Ivar < Basic
      def value(analysis, args_predictor)
        Evaluation.new(@body.to_a.first.to_s)
      end
    end
  end
end
