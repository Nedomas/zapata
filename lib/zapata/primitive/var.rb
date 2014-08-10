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

      def to_raw
        raw = Diver.dive(node.body).to_raw

        if raw.type == :super
          binding.pry
          Missing.new(node.name).to_raw
        else
          raw
        end
      end
    end
  end
end
