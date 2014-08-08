module Zapata
  module Primitive
    class Hash < Base
      def node
        body = @code
        type = @code.type
        OpenStruct.new(type: type, body: body)
      end

      def to_a
        value.to_a.flatten
      end

      def dive_deeper
      end

      def to_raw
        result = {}

        node.body.to_a.each do |pair|
          key_node, value_node = pair.to_a
          key = Diver.dive(key_node).to_raw
          value = Diver.dive(value_node).to_raw
          result[key] = value
        end

        Raw.new(:hash, result)
      end
    end
  end
end
