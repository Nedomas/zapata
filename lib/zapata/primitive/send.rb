module Zapata
  module Primitive
    class Send < Base
      def to_a
        [value]
      end

      def node
        receiver, name, args = @code.to_a
        type = @code.type
        OpenStruct.new(type: type, name: name, args: args, receiver: receiver)
      end

      def raw_receiver
        Diver.dive(node.receiver).to_raw rescue binding.pry
      end

      def to_raw
        Raw.new(:send, "#{Printer.print(raw_receiver)}.#{node.name}#{Predictor::Args.literal(node.args)}")
      end
    end
  end
end
