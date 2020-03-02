# frozen_string_literal: true

module Zapata
  module Primitive
    class Arg < Base
      def node
        name = @code.to_a.first
        type = @code.type
        OpenStruct.new(type: type, name: name, body: @code)
      end

      def to_raw
        chosen_value = Predictor::Value.new(node.name, self).choose.to_raw
        return_with_super_as_missing(chosen_value, self)
      end
    end
  end
end
