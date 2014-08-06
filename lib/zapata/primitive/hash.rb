module Zapata
  module Primitive
    class PrimitiveHash
      def initialize(code, diver)
        @body = code
        @diver = diver
      end

      def to_a(analysis, args_predictor)
        value(analysis, args_predictor).to_a.flatten
      end

      def value(analysis, args_predictor)
        result = {}

        @body.to_a.each do |pair|
          key_node, value_node = pair.to_a
          key = @diver.dive(key_node).value(analysis, args_predictor)
          value = @diver.dive(value_node).value(analysis, args_predictor)
          result[key] = value
        end

        result
      end
    end
  end
end
