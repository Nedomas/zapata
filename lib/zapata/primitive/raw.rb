module Zapata
  module Primitive
    class Raw
      attr_accessor :type, :value

      def initialize(type, value)
        @type = type
        @value = value
      end

      def to_raw
        self
      end
    end
  end
end
