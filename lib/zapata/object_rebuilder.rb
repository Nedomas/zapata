module Zapata
  class ObjectRebuilder
    class << self
      def rebuild(value, var_analysis, args_predictor)
        return value unless value.respond_to?(:type)

        type = value.type
        # body = value.body

        case type
        when :str, :int, :sym
          value.value(var_analysis, args_predictor)
        when :true
          true
        when :false
          false
        when :hash
          value.value(var_analysis, args_predictor)
        when :send
          rebuild(value.value(var_analysis, args_predictor), var_analysis, args_predictor) rescue binding.pry
          # Evaluation.new(body)
        when :lvar
          rebuild(value.value(var_analysis, args_predictor), var_analysis, args_predictor)
        when :arg, :optarg
          value.name
        when :ivar
          binding.pry
          value.body.to_a.last.to_s
        when nil
          nil
        else
          binding.pry
        end
      end
    end
  end
end
