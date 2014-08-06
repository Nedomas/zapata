module Zapata
  module Primitive
    class Base
      def initialize(code)
        @code = code
        dive_deeper
      end

      def name
        SaveManager.clean(node.name)
      end

      def dive_deeper
        if node.body and !RETURN_TYPES.include?(node.type)
          Diver.dive(node.body)
        end
      end

      def value
        Diver.dive(node.body).value
      end
    end
  end
end
