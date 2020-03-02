# frozen_string_literal: true

module Zapata
  module Primitive
    class Modul < Base
      def initialize(code)
        @code = code
        Diver.current_moduls << self
        dive_deeper
        Diver.current_moduls.pop
      end

      def node
        const, body = @code.to_a
        modul, name = const.to_a
        type = @code.type

        OpenStruct.new(type: type, modul: modul, name: name, body: body)
      end
    end
  end
end
