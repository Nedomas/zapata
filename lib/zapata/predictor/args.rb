module Zapata
  module Predictor
    class Args
      class << self
        def literal(args_node)
          raw_args = Diver.dive(args_node).to_raw
          chosen_args = choose_values(raw_args)

          args_in_string = case chosen_args
#           when Array
#             rebuilt = chosen_args.map do |primitive|
#               Printer.print(primitive)
#             end
#
#             raw_array = Primitive::Raw.new(:array, rebuilt)
#             Printer.print(raw_array)
#           when Hash
#             rebuilt = chosen_args.each_with_object({}) do |(key, val), obj|
#               obj[Printer.print(key)] = Printer.print(val)
#             end
#
#             raw_hash = Primitive::Raw.new(:hash, rebuilt)
#             Printer.print(raw_hash)
          when Primitive::Raw
            Printer.print(chosen_args)
          else
            raise 'Not yet implemented'
          end

          Printer.args(args_in_string, chosen_args.type)
        end

        def choose_values(raw_args)
          case raw_args.type
          when :array
            array = raw_args.value.map do |arg|
              Value.new(arg.value, arg).choose.to_raw
            end

            Primitive::Raw.new(:array, array)
          when :hash
            hash = raw_args.value.each_with_object({}) do |(rkey, rval), obj|
              key = Value.new(rkey.value, rkey).choose.to_raw
              val = Value.new(rval.value, rval).choose.to_raw
              obj[key] = val
            end

            Primitive::Raw.new(:hash, hash)
          when :int
            Primitive::Raw.new(:int, raw_args.value)
          when :missing
            Primitive::Raw.new(:missing, raw_args.value)
          when :nil
            Primitive::Nil.new.to_raw
          else
            raise 'Not yet implemented'
          end
        end
      end
    end
  end
end
