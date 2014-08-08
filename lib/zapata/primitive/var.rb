module Zapata
  module Primitive
    class Var < Base
      def node
        name, body = @code.to_a
        type = @code.type
        OpenStruct.new(type: type, name: name, body: body)
      end

      def literal
        Diver.dive(node.body).literal
      end
    end
  end
end
