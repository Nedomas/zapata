module Zapata
  class ObjectRebuilder
    class << self
      def rebuild(object)
        object.type rescue binding.pry
      end

      def node_rebuild(object, type)
        case object.type
        when :str
          Printer.print(object.to_a.last)
        when :int
          Printer.print(object.to_a.last)
        when :sym
          Printer.print(object.to_a.last)
        when :true
          Printer.print(true)
        when :false
          Printer.print(false)
        when :hash
          Printer.print(hash(object))
        when :send
          Diver.dive(object).value
          binding.pry
          "SEND"
          # binding.pry
          # rebuild(value.value(var_analysis, args_predictor), var_analysis, args_predictor) rescue binding.pry
          # Evaluation.new(body)
        when :lvar
          binding.pry
          # rebuild(value.value(var_analysis, args_predictor), var_analysis, args_predictor)
        when :arg, :optarg
          binding.pry
          value.name
        when :ivar
          binding.pry
          value.body.to_a.last.to_s
        when :missing
          binding.pry
          object.literal
        when :raw
          Printer.print(object)
        when nil
          binding.pry
          nil
        else
          binding.pry
        end
      end

      def hash(body)
        result = {}

        body.to_a.each do |pair|
          key_node, value_node = pair.to_a
          key = rebuild(key_node)
          value = rebuild(value_node)
          result[key] = value
        end

        result
      end
    end
  end
end
