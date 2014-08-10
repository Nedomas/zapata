module Zapata
  module Primitive
    class Base
      attr_accessor :code, :type

      def initialize(code)
        @code = code
        @type = code.type
        dive_deeper
      end

      def name
        SaveManager.clean(node.name)
      end

      def dive_deeper
        unless RETURN_TYPES.include?(node.type)
          Diver.dive(node.args)
          Diver.dive(node.body)
        end
      end

      def to_raw
        Diver.dive(node.body).to_raw
      end
    end
  end
end
