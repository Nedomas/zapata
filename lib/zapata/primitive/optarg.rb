module Zapata
  module Primitive
    class Optarg < Basic
      def node
        name, body = @code.to_a
        OpenStruct.new(type: @code.type, name: name, body: body)
      end

      def to_raw
        Diver.dive(node.body.to_a.last).to_raw
      end
    end
  end
end
