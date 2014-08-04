module Zapata
  class ArgsPredictor
    MISSING_TYPES = %i(lvar send)
    PRIMITIVE_TYPES = %i(str sym int array true false hash)

    def initialize(args, var_analysis, instance)
      @args = args
      @var_analysis = var_analysis
      @instance = instance
    end

    def to_s
      heuristic_args = calculate_heuristic_args
      !heuristic_args.empty? ? "(#{heuristic_args.join(', ')})" : ''
    end

    def calculate_heuristic_args
      a = @args.to_a.map do |arg|
        var_name = arg.to_a.first
        # fallback if not found
        value = choose_arg_value(var_name)
        Writer.arg_for_print(value)
      end
      a
    end

    def choose_arg_value(var_name)
      possible_values = @var_analysis[var_name] || []
      return Missing.new(:never_set, var_name) if possible_values.empty?

      value = Chooser.new(possible_values).by_probability
      return_value_by_type(value[:value], value[:type], var_name)
    end

    def return_value_by_type(value, type, var_name)
      if MISSING_TYPES.include?(type) and @instance.initialized?
        @instance.new.send(value)
      elsif PRIMITIVE_TYPES.include?(type)
        value
      elsif type == :send
        Evaluation.new(value)
      else
        Missing.new(:not_calculatable, var_name)
      end
    end
  end
end
