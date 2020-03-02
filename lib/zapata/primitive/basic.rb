# frozen_string_literal: true

module Zapata
  module Primitive
    class Basic < Base
      def to_a
        [value]
      end

      def node
        body = @code
        type = @code.type
        OpenStruct.new(type: type, body: body)
      end

      def to_raw
        Raw.new(node.body.type, node.body.to_a.last)
      end
    end
  end
end
