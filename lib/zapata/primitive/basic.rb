module Zapata
  module Primitive
    class Basic
      attr_reader :name, :type, :body

      def initialize(code, diver)
        @type = code.type if code
        @diver = diver
        @body = code
      end

      def to_a(analysis, args_predictor)
        [ObjectRebuilder.rebuild(self, analysis, args_predictor)]
      end

      def value(*)
        @body.to_a.first
      end
    end
  end
end
