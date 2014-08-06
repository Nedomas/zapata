module Zapata
  module Predictor
    class Args
      class << self
        def predict(args_node)
          literal_args = Diver.dive(args_node).value

          choose_values(literal_args)
        end

        def literal(args_node)
          binding.pry
        end

        def choose_values(literal_args)
          literal_args.map do |arg|
            choose_value(arg)
          end
        end

        def choose_value(name)
          possible_values = Revolutionist.analysis_as_array.select do |v|
            v.name == name
          end

          return 'Missing.new(:never_set, name)' if possible_values.empty?

          chosen = Chooser.new(possible_values).by_probability
          chosen.value
          # binding.pry
          # ObjectRebuilder.rebuild(value)
        end
      end

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

    end
  end
end
