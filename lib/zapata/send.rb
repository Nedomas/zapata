module Zapata
  class Send
    attr_reader :name, :type

    def initialize(code, diver)
      @type = :send
      @body = code
      @to_object, method, args = code.to_a
      @args = if args
        diver.dive(args) rescue binding.pry
      else
        Primitive.new(nil, diver)
      end

      @name = SaveManager.clean(method)
    end

    def to_a(analysis)
      [value(analysis)]
    end

    def body(analysis)
      # add args
      "#{object_constant}.#{name}#{ArgsPredictor.new(@args, analysis, nil)}" rescue binding.pry
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
