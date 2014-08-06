module Zapata
  module Primitive
    class Send < Base
      def to_a
        [value]
      end

      def node
        receiver, name, args = @code.to_a
        type = @code.type
        OpenStruct.new(type: type, name: name, args: args, receiver: receiver)
      end

      def receiver_constant
        node.receiver.to_a.compact.join('::')
      end

      def literal
        "#{receiver_constant}.#{node.name}#{Predictor::Args.literal(node.args)}"
      end

      def value
        definition = Revolutionist.analysis_as_array.detect do |assignment|
          assignment.class == Def and assignment.name == node.name
        end
        return unless definition

        if @to_object
          Eval.new(literal)
        else
          definition.value
        end
      end
    end
  end
end
