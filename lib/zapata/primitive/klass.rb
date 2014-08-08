module Zapata
  module Primitive
    class Klass < Base
      def initialize(code)
        @code = code
        Diver.current_klass = self
        dive_deeper
        Diver.current_klass = nil
      end

      def node
        const, inherited_from_klass, body = @code.to_a
        modul, name = const.to_a
        type = @code.type

        OpenStruct.new(type: type, modul: modul, name: name, body: body)
      end
    end
  end
end
