module Zapata
  class DefAssignment
    attr_reader :name, :args, :body, :type

    def initialize(code, diver)
      name, args, body = code.to_a

      @name = SaveManager.clean(name)
      @args = args
      @body = body
      return unless @body
      @type = @body.type
      @diver = diver

      if !RETURN_TYPES.include?(@type)
        @diver.dive(@body)
      end
    end

    def value(analysis)
      @diver.dive(@body).value(analysis)
    end

  end

  class Primitive
    attr_reader :name, :type, :body

    def initialize(code, diver)
      @type = code.type
      @body = code
    end

    def value(analysis)
      @body.to_a.first
    end
  end

  class Send
    attr_reader :name, :type, :body

    def initialize(code, diver)
      @type = :send
      @to_object, method, *@args = code.to_a

      @name = SaveManager.clean(method)
    end

    def value(analysis)
      definition = analysis.find do |assignment|
        assignment.class == Zapata::DefAssignment and assignment.name == @name
      end

      definition.value(analysis) rescue binding.pry
    end
  end
end
