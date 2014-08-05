module Zapata
  class ArgsPredictor
    MISSING_TYPES = %i(lvar send)
    PRIMITIVE_TYPES = %i(str sym int array true false)

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
        Printer.value(value)
      end
      a
    end

    def choose_arg_value(var_name)
      possible_values = @var_analysis[var_name] || []
      return Missing.new(:never_set, var_name) if possible_values.empty?

      value = Chooser.new(possible_values).by_probability
      return_value_by_type(value[:code], value[:type], var_name)
    end

    def return_value_by_type(code, type, var_name)
      if MISSING_TYPES.include?(type) and @instance.initialized?
        @instance.new.send(code)
      elsif PRIMITIVE_TYPES.include?(type)
        code
      elsif type == :send
        Evaluation.new(code)
      elsif type == :hash
        result = {}

        code.each do |key, val|
          result[key[:code]] = val[:code]
        end

        result
      else
        Missing.new(:not_calculatable, var_name)
      end
    end
  end
end
