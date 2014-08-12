module Zapata
  module Primitive
    class Const < Basic
      def node
        modul, klass = @code.to_a
        type = @code.type
        OpenStruct.new(modul: modul, klass: klass, type: type)
      end

      def to_raw
        Raw.new(:const, [node.modul, node.klass].compact.join('::'))
      end
    end
  end
end
