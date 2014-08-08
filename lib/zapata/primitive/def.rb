module Zapata
  module Primitive
    class Def < Base
      def node
        name, args, body = @code.to_a
        type = @code.type
        binding.pry if name == :find
        OpenStruct.new(type: type, name: name, args: args, body: body)
      end

      def literal_predicted_args
        Predictor::Args.literal(node.args)
      end
    end
  end
end
