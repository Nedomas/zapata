module Zapata
  class MethodMock
    attr_reader :name

    def initialize(name, args, body, var_analysis, instance)
      @name = name
      @args = args
      @body = body
      @var_analysis = var_analysis
      @instance = instance
    end

    def empty?
      !@body
    end

    def predicted_args_to_s
      ArgsPredictor.new(@args, @var_analysis, @instance).to_s
    end
  end
end
