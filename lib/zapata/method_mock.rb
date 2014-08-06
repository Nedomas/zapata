module Zapata
  class MethodMock
    attr_reader :name

    def initialize(name, args, body, var_analysis, instance)
      @name = name
      @args = args
      @body = body
      @var_analysis = var_analysis
      @instance = instance
      @args_predictor = ArgsPredictor.new(@args, @var_analysis, @instance)
    end

    def arg_ivars
      @args_predictor.ivars
    end

    def empty?
      !@body
    end

    def predicted_args_to_s
      @args_predictor.to_s
    end
  end
end
