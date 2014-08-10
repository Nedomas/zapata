module Zapata
  module Primitive
    class Optarg < Base
      def node
        name, body = @code.to_a
        type = @code.type
        OpenStruct.new(type: type, name: name, body: body)
      end

      def dive_deeper
      end

      def to_raw
        Diver.dive(node.body).to_raw
      end
    end
  end
end
