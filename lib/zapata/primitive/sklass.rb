# frozen_string_literal: true

module Zapata
  module Primitive
    class Sklass < Base
      def initialize(code)
        @code = code

        Diver.current_sklass = self
        dive_deeper
        Diver.current_sklass = nil
      end

      def node
        _, body = @code.to_a
        type = @code.type

        OpenStruct.new(type: type, body: body)
      end
    end
  end
end
