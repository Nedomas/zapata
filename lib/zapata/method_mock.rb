module Zapata
  class MethodMock
    attr_reader :name

    def initialize(name, args, body, var_analysis, instance)
      @name = name
      @args = args
      @var_analysis = var_analysis
      @instance = instance
    end

    def predicted_args_to_s
      ArgsPredictor.new(@args, @var_analysis, @instance).to_s
    end
  end
end
