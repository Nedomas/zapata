module Zapata
  module Primitive
    class Arg < Base
      def node
        name = @code.to_a.first
        type = @code.type
        OpenStruct.new(type: type, name: name, body: @code)
      end

      def dive_deeper
      end

      def to_raw
        chosen_value = Predictor::Args.choose_value(node.name, self).to_raw

        if chosen_value.type == :super
          Missing.new(chosen_value.value).to_raw
        else
          chosen_value
        end rescue binding.pry
      end
    end
  end
end
