module Zapata
  module Primitive
    class Missing
      def initialize(name)
        @name = name
      end

      def node
        OpenStruct.new(type: :missing)
      end

      def to_raw
        Raw.new(:missing, @name)
      end
    end
  end
end
