module Zapata
  class MissingVariable
    def initialize(*parameters)
      @parameters = parameters
    end

    def to_s
      printable_params = @parameters.map do |param|
        Writer.arg_for_print(param)
      end

      "Zapata::MissingVariable.new(#{printable_params.join(', ')})"
    end
  end
end
