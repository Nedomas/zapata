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
      !heuristic_args.empty? ? "(#{heuristic_args.join(', ')})" : ''
    end

    def calculate_heuristic_args
      a = @args.to_a(@var_analysis).map do |arg|
        # fallback if not found
        value = choose_arg_value(arg)
        Printer.value(value)
      end rescue binding.pry
      a
    end

    def choose_arg_value(var_name)
      possible_values = @var_analysis.select { |v| v.name == var_name }
      return Missing.new(:never_set, var_name) if possible_values.empty?

      value = Chooser.new(possible_values).by_probability
      ObjectRebuilder.rebuild(value, @var_analysis)
    end
  end

  class ObjectRebuilder
    class << self
      def rebuild(value, var_analysis)
        return value unless value.respond_to?(:type)

        type = value.type
        # body = value.body

        case type
        when :str, :int, :sym
          value.value(var_analysis)
        when :true
          true
        when :false
          false
        when :hash
          # hash = value.value(var_analysis)
          hash(value.body)
        when :send
          rebuild(value.value(var_analysis), var_analysis)
          # Evaluation.new(body)
        when :lvar
          rebuild(value.value(var_analysis), var_analysis)
        when :arg, :optarg
          value.name
        else
          binding.pry
        end
      end

      def hash(body)
        result = {}

        pairs = body.to_a
        pairs.each do |pair|
          key_node, value_node = pair.to_a
          key = key_node.to_a.first rescue binding.pry
          value = value_node.to_a.first
          result[key] = value
        end

        result
      end
    end
  end
end
