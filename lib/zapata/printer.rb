module Zapata
  class Printer
    class << self
      def value(what)
        case what
        when String
          # decide which one to use
          # "\"#{value}\""
          "'#{what}'"
        when Symbol
          ":#{what}"
        when Evaluation
          what.to_s
        when Hash
          hash(what)
        else
          what
        end
      end

      def join_args(args_array, args_obj)
        if args_obj.is_a?(PrimitiveHash)
          hash(args_array.each_slice(2).to_h)
        elsif args_obj.is_a?(PrimitiveArray)
          args_array.map { |arg| value(arg) }.join(', ')
        elsif args_obj.is_a?(Primitive)
          value(args_array.first) rescue binding.pry
        else
          binding.pry
        end
      end

      def hash(obj)
        values = obj.map do |key, val|
          "#{value(key)} => #{value(val)}"
        end

        "{ #{values.join(', ')} }"
      end
    end
  end
end
