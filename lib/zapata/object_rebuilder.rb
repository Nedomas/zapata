module Zapata
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
          value.value(var_analysis)
        when :send
          rebuild(value.value(var_analysis), var_analysis)
          # Evaluation.new(body)
        when :lvar
          rebuild(value.value(var_analysis), var_analysis)
        when :arg, :optarg
          value.name
        when :ivar
          binding.pry
          value.body.to_a.last.to_s
        else
          binding.pry
        end
      end
    end
  end
end
