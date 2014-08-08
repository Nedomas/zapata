module Zapata
  module Predictor
    class Args
      class << self
        def literal(args_node)
          raw_args = Diver.dive(args_node).to_raw
          chosen_args = choose_values(raw_args)

          literal_args = case chosen_args
          when Array
            rebuilt = chosen_args.map do |primitive|
              Printer.print(primitive)
            end

            raw_array = Primitive::Raw.new(:array, rebuilt)
            Printer.print(raw_array)
          when Hash
            rebuilt = chosen_args.each_with_object({}) do |(key, val), obj|
              obj[Printer.print(key)] = Printer.print(val)
            end

            raw_hash = Primitive::Raw.new(:hash, rebuilt)
            Printer.print(raw_hash)
          when Integer
            raw_int = Primitive::Raw.new(:int, chosen_args)
            Printer.print(raw_int)
          when NilClass
          else
            binding.pry
          end

          Printer.args(literal_args)
        end

        def choose_values(raw_args)
          case raw_args.type
          when :array
            raw_args.value.map do |arg|
              choose_value(arg.value).to_raw
            end
          when :hash
            raw_args.value.each_with_object({}) do |(rkey, rval), obj|
              key = if RETURN_TYPES.include?(rkey.type)
                rkey
              else
                choose_value(rkey.value).to_raw
              end

              val = if RETURN_TYPES.include?(rval.type)
                rval
              else
                choose_value(rval.value).to_raw
              end

              obj[key] = val
            end
          when :int
            raw_args.value
          end
        end

        def choose_value(name)
          possible_values = Revolutionist.analysis_as_array.select do |v|
            v.name == name
          end

          if possible_values.empty?
            return Primitive::Missing.new(name)
          end

          Chooser.new(possible_values).by_probability
        end
      end
    end
  end
end
