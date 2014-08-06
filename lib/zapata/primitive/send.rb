module Zapata
  module Primitive
    class Send
      attr_reader :name, :type

      def initialize(code, diver)
        @type = :send
        @body = code
        @to_object, method, args = code.to_a
        @args = if args
          diver.dive(args) rescue binding.pry
        else
          Arg.new(nil, diver)
        end

        @name = SaveManager.clean(method)
      end

      def to_a(analysis, args_predictor)
        [value(analysis, args_predictor)]
      end

      def body(analysis, args_predictor)
        # add args
        "#{object_constant}.#{name}#{ArgsPredictor.new(@args, analysis, nil, args_predictor.ivars)}"
      end

      def object_constant
        @to_object.to_a.compact.join('::')
      end

      def value(analysis, args_predictor)
        definition = analysis.find do |assignment|
          assignment.class == Zapata::DefAssignment and assignment.name == @name
        end

        if @to_object
          Evaluation.new(body(analysis, args_predictor))
        else
          definition.value(analysis, args_predictor) rescue binding.pry
        end
      end
    end
  end
end
