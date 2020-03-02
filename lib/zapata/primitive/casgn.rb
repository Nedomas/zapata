# frozen_string_literal: true

module Zapata
  module Primitive
    class Casgn < Base
      def node
        modul, name, body = @code.to_a
        type = @code.type
        OpenStruct.new(type: type, modul: modul, name: name, body: body)
      end

      def literal
        Diver.dive(node.body).literal
      end
    end
  end
end
