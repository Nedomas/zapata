module Zapata
  module Primitive
    class Missing
      def initialize(*parameters)
        @parameters = parameters
      end

      def literal
        # literal_symbols = @parameters.map { |p| Printer.print(p) }
        # "Zapata::Primitive::Missing.new(#{literal_symbols.join(', ')})"
      end

      def node
        OpenStruct.new(type: :missing, body: mocked_body_node)
      end

      def mocked_body_node
        OpenStruct.new(type: :missing, literal: literal)
      end

      def to_raw
        Raw.new(:str, literal)
      end
    end
  end
end
