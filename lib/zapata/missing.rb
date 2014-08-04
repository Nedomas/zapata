module Zapata
  class Missing
    def initialize(*parameters)
      @parameters = parameters
    end

    def to_s
      printable_params = @parameters.map do |param|
        Printer.value(param)
      end

      "Zapata::Missing.new(#{printable_params.join(', ')})"
    end
    alias_method :to_str, :to_s

    def method_missing(m, *args, &block)
      self
    end
  end
end
