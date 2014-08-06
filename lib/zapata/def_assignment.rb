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

    def value(analysis)
      @diver.dive(@body).value(analysis)
    end
  end

  class Primitive
    attr_reader :name, :type, :body

    def initialize(code, diver)
      @type = code.type if code
      @diver = diver
      @body = code
    end

    def to_a(analysis)
      [ObjectRebuilder.rebuild(self, analysis)]
    end

    def value(analysis)
      ObjectRebuilder.rebuild(self, analysis)
    end
  end

  class Arg < Primitive
    def initialize(code, diver)
      @type = code.type
      @body = code
      @name = code.to_a.first
    end
  end

  class PrimitiveArray
    def initialize(code, diver)
      @body = code
      @diver = diver
    end

    def to_a(analysis)
      value(analysis)
    end

    def value(analysis)
      @body.to_a.map do |element|
        @diver.dive(element).value(analysis)
      end
    end
  end

  class Send
    attr_reader :name, :type

    def initialize(code, diver)
      @type = :send
      @to_object, method, args = code.to_a
      @args = if args
        diver.dive(args) rescue binding.pry
      else
        Primitive.new(nil, diver)
      end

      @name = SaveManager.clean(method)
    end

    def body(analysis)
      # add args
      "#{object_constant}.#{name}(#{ArgsPredictor.new(@args, analysis, nil)})" rescue binding.pry
    end

    def object_constant
      @to_object.to_a.compact.join('::')
    end

    def value(analysis)
      definition = analysis.find do |assignment|
        assignment.class == Zapata::DefAssignment and assignment.name == @name
      end

      if @to_object
        Evaluation.new(body(analysis))
      else
        definition.value(analysis) rescue binding.pry
      end
    end
  end
end
