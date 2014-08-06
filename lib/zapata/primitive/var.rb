module Zapata
  module Primitive
    class VarAssignment
      attr_reader :name, :type, :body

      def initialize(code, diver)
        parts = code.to_a

        @name = SaveManager.clean(parts.first)
        @body = parts.last
        return unless @body
        @type = @body.type
        @diver = diver

        if !RETURN_TYPES.include?(@type)
          @diver.dive(@body)
        end
      end

      def value(analysis, args_predictor)
        @diver.dive(@body).value(analysis, args_predictor)
      end
    end
  end
end
