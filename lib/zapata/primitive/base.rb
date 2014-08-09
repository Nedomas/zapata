module Zapata
  module Primitive
    class Base
      attr_accessor :code

      def initialize(code)
        @code = code
        dive_deeper
      end

      def name
        SaveManager.clean(node.name)
      end

      def dive_deeper
        if !RETURN_TYPES.include?(node.type)
          Diver.dive(node.body)
        end
      end

      def to_raw
        raw = Diver.dive(node.body).to_raw
        if raw.type == :super
          Missing.new(node.name).to_raw
        else
          Raw.new(raw.type, raw.value)
        end
      end
    end
  end
end
