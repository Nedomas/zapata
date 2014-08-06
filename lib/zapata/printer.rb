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
        else
          what
        end
      end

      def join_args(args_array, args_obj)
        if args_obj.is_a?(PrimitiveHash)
          hash(args_array.each_slice(2).to_h)
        elsif args_obj.is_a?(PrimitiveArray)
          args_array.join(', ')
        else
          binding.pry
        end
      end

      def hash(obj)
        result = '{ '

        obj.each do |key, val|
          result += "#{value(key)} => #{value(val)}"
        end

        result += ' }'

        result
      end
    end
  end
end
