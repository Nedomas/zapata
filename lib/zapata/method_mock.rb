module Zapata
  class MethodMock
    attr_reader :name

    def initialize(name, args, body, var_analysis)
      @name = name
      @args = args
      @var_analysis = var_analysis
    end

    def predicted_args_to_s
      @args_predictor = ArgsPredictor.new(@args, @var_analysis).to_s
    end
  end
end
