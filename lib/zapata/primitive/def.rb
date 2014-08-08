module Zapata
  module Primitive
    class Def < Base
      attr_accessor :klass

      def initialize(code)
        @code = code
        @klass = Diver.current_klass
        @self = Diver.current_sklass
        @access_level = Diver.access_level
        @modul = Diver.current_modul
        dive_deeper
      end

      def self?
        !!@self
      end

      def public?
        @access_level == :public
      end

      def node
        name, args, body = @code.to_a
        type = @code.type
        OpenStruct.new(type: type, name: name, args: args, body: body)
      end

      def literal_predicted_args
        Predictor::Args.literal(node.args)
      end
    end
  end
end
