module Zapata
  module Predictor
    class Args
      class << self
        def literal(args_node)
          raw_args = Diver.dive(args_node).to_raw
          chosen_args = choose_values(raw_args)

          args_in_string = case chosen_args
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
            nil
          when Symbol
            raw_sym = Primitive::Raw.new(:sym, chosen_args)
            Printer.print(raw_sym)
          else
            raise "Not yet implemented"
          end

          Printer.args(args_in_string, chosen_args.class)
        end

        def choose_values(raw_args)
          case raw_args.type
          when :array
            raw_args.value.map do |arg|
              if (RETURN_TYPES + [:array, :hash]).include?(arg.type)
                arg
              else
                choose_value(arg.value, arg).to_raw
              end
            end
          when :hash
            raw_args.value.each_with_object({}) do |(rkey, rval), obj|
              key = if RETURN_TYPES.include?(rkey.type)
                rkey
              else
                choose_value(rkey.value, rkey).to_raw
              end

              val = if RETURN_TYPES.include?(rval.type)
                rval
              else
                choose_value(rval.value, rval).to_raw
              end

              obj[key] = val
            end
          when :int, :missing, :nil
            raw_args.value
          else
            raise "Not yet implemented"
          end
        end

        def choose_value(name, finder = nil)
          return Primitive::Raw.new(:nil, nil) if name.nil?
          return finder if finder and RETURN_TYPES.include?(finder.type)

          possible_values = Revolutionist.analysis_as_array.select do |element|
            !is_a_finder?(element, finder) and element.name == name
          end

          if possible_values.empty?
            return Primitive::Raw.new(:super, name)
          end

          Chooser.new(possible_values).by_probability
        end

        def is_a_finder?(primitive, finder)
          return false unless finder
          primitive.class == finder.class and primitive.name == finder.name
        end
      end
    end
  end
end
