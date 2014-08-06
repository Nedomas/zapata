module Zapata
  module Primitive
    class Array
      def initialize(code, diver)
        @body = code
        @diver = diver
      end

      def to_a(analysis, args_predictor)
        value(analysis, args_predictor)
      end

      def value(analysis, args_predictor)
        @body.to_a.map do |element|
          @diver.dive(element).value(analysis, args_predictor)
        end
      end
    end
  end
end
