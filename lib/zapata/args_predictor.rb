module Zapata
  class ArgsPredictor
    MISSING_TYPES = %i(lvar)
    PRIMITIVE_TYPES = %i(str sym int array true false)

    def initialize(args, var_analysis, instance)
      @args = args
      @var_analysis = var_analysis
      @instance = instance
    end

    def to_s
      heuristic_args = calculate_heuristic_args
      !heuristic_args.empty? ? "(#{heuristic_args})" : ''
    end

    def calculate_heuristic_args
      calculated_args = @args.to_a(@var_analysis).map do |arg|
        arg.is_a?(Evaluation) ? arg : choose_arg_value(arg)
      end

      Printer.join_args(calculated_args, @args)
    end

    def choose_arg_value(var_name)
      possible_values = @var_analysis.select { |v| v.name == var_name }
      return Missing.new(:never_set, var_name) if possible_values.empty?

      value = Chooser.new(possible_values).by_probability
      ObjectRebuilder.rebuild(value, @var_analysis)
    end
  end
end
