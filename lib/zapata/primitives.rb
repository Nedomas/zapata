module Zapata
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
      @body.to_a.first
    end
  end

  class PrimitiveArg < Primitive
    def name
      @body.to_a.first
    end
  end

  class PrimitiveIvar < Primitive
    def value(analysis)
      Evaluation.new(@body.to_a.first.to_s)
    end
  end

  class PrimitiveHash
    def initialize(code, diver)
      @body = code
      @diver = diver
    end

    def to_a(analysis)
      value(analysis).to_a.flatten
    end

    def value(analysis)
      result = {}

      @body.to_a.each do |pair|
        key_node, value_node = pair.to_a
        key = @diver.dive(key_node).value(analysis)
        value = @diver.dive(value_node).value(analysis)
        result[key] = value
      end

      result
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
end
