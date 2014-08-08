module Zapata
  module Primitive
    class Defs < Base
      attr_accessor :klass

      def initialize(code)
        @code = code
        @klass = Diver.current_klass
        @access_level = Diver.access_level
        dive_deeper
      end

      def self?
        true
      end

      def public?
        @access_level == :public
      end

      def node
        receiver, name, args, body = @code.to_a
        type = @code.type
        OpenStruct.new(type: type, name: name, args: args, body: body)
      end

      def literal_predicted_args
        Predictor::Args.literal(node.args)
      end
    end
  end
end
