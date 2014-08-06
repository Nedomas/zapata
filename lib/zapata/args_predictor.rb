module Zapata
  class ArgsPredictor
    MISSING_TYPES = %i(lvar)
    PRIMITIVE_TYPES = %i(str sym int array true false)
    attr_reader :ivars

    def initialize(args, var_analysis, instance, ivars = [])
      @ivars = ivars
      @args = args
      @var_analysis = var_analysis
      @instance = instance
      @heuristic_args = calculate_heuristic_args
    end

    def to_s
      !@heuristic_args.empty? ? "(#{@heuristic_args})" : '' rescue binding.pry
    end

    def calculate_heuristic_args
      calculated_args = @args.to_a(@var_analysis, self).map do |arg|
        if arg.is_a?(Integer)
          [arg]
        else
          if arg.is_a?(Evaluation)
            @ivars << arg
            arg
          else
            choose_arg_value(arg, self)
          end
        end
      end

      Printer.join_args(calculated_args, @args)
    end

    def choose_arg_value(var_name, args_predictor)
      possible_values = @var_analysis.select { |v| v.name == var_name }
      return Missing.new(:never_set, var_name) if possible_values.empty?

      value = Chooser.new(possible_values).by_probability
      ObjectRebuilder.rebuild(value, @var_analysis, args_predictor)
    end
  end
end
