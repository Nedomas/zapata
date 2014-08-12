module Zapata
  module Primitive
    class Lvar < Base
      def node
        name = @code.to_a.first
        type = @code.type
        OpenStruct.new(type: type, name: name, body: @code)
      end

      def to_raw
        chosen_value = Predictor::Value.new(node.name, self).choose

        if chosen_value.node.body == node.body
          Missing.new(node.name).to_raw
        else
          chosen_value.to_raw
        end
      end
    end
  end
end
