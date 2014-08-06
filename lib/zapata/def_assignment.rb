module Zapata
  class DefAssignment
    attr_reader :name, :args, :body, :type

    def initialize(code, diver)
      name, args, body = code.to_a

      @name = SaveManager.clean(name)
      @args = diver.dive(args)
      @body = body
      return unless @body
      @type = @body.type
      @diver = diver

      if !RETURN_TYPES.include?(@type)
        @diver.dive(@body)
      end
    end

    def value(analysis, args_predictor)
      @diver.dive(@body).value(analysis, args_predictor)
    end
  end
end
