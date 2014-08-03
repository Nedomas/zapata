module Zapata
  class InstanceMock
    attr_reader :body, :name
    attr_accessor :args_to_s

    def initialize(name_node, inherited_from_klass, body)
      @body = body
      @module, @name = name_node.to_a
    end

    def initialize_to_s
      "#{@name}.new#{@args_to_s}"
    end

    def name_underscore
      @name.to_s.underscore
    end
  end

  class ArgsPredictor
    MISSING_TYPES = %i(lvar send)
    PRIMITIVE_TYPES = %i(str sym int array true false hash)

    def initialize(args, var_analysis)
      @args = args
      @var_analysis = var_analysis
    end

    def to_s
      !heuristic_args.empty? ? "(#{heuristic_args.join(', ')})" : ''
    end

    def heuristic_args
      @args.to_a.map do |arg|
        var_name = arg.to_a.first
        # fallback if not found
        value = choose_arg_value(var_name)
        Writer.arg_for_print(value)
      end
    end

    def choose_arg_value(var_name)
      possible_values = @var_analysis[var_name] || []
      return MissingVariable.new(:never_set, var_name) if possible_values.empty?

      value = choose_by_probability(possible_values)

      type = value[:type]

      if MISSING_TYPES.include?(type)
        MissingVariable.new(value[:type], value[:value])
      elsif PRIMITIVE_TYPES.include?(type)
        value[:value]
      else
        binding.pry
      end
    end

    def choose_by_probability(possible_values)
      return if possible_values.empty?

      most_probable_by_count = most_probable_by_counts(possible_values)

      result = if PRIMITIVE_TYPES.include?(most_probable_by_count[:type])
        most_probable_by_count
      else
        possible_values.delete(most_probable_by_count)
        choose_by_probability(possible_values)
      end

      result || most_probable_by_count
    end

    def most_probable_by_counts(possible_values)
      group_with_counts(possible_values).max_by { |k, v| v }.first
    end

    def group_with_counts(values)
      values.each_with_object(Hash.new(0)) do |value, obj|
        obj[value] += 1
      end
    end
  end

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
