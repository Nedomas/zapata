module Zapata
  module Primitive
    class ConstSend
      def initialize(raw_receiver, method_name, args)
        @raw_receiver = raw_receiver
        @method_name = method_name
        @args = args
      end

      def node
        OpenStruct.new(method_name: @method_name, args: @args)
      end

      def to_raw
        Raw.new(:const_send, "#{Printer.print(@raw_receiver)}.#{node.method_name}#{Predictor::Args.literal(node.args)}")
      end
    end
  end
end
