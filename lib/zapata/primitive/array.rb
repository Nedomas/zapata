module Zapata
  module Primitive
    class Array < Base
      def node
        body = @code
        type = @code.type
        OpenStruct.new(type: type, body: body)
      end

      def to_a
        value
      end

      def to_raw
        value = node.body.to_a.map do |node|
          primitive = Diver.dive(node)
          raw = primitive.to_raw

          if raw.type == :super
            predicted = Predictor::Value.new(raw.value).choose.to_raw
            return_with_super_as_missing(predicted, primitive.name)
          else
            raw
          end
        end

        Raw.new(:array, value)
      end
    end
  end
end
