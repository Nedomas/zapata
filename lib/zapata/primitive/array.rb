module Zapata
  module Primitive
    class Array < Base
      def node
        body = @code
        type = @code.type
        OpenStruct.new(type: type, body: body)
      end

      def dive_deeper
      end

      def to_a
        value
      end

      def value
        node.body.to_a.map do |element|
          Diver.dive(element).value
        end
      end
    end
  end
end
