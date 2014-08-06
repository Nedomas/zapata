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

      def value
        result = {}

        node.body.to_a.each do |pair|
          key_node, value_node = pair.to_a
          key = Diver.dive(key_node)
          value = Diver.dive(value_node)
          result[key] = value
        end

        result
      end
    end
  end
end
