module Zapata
  class SaveManager
    def self.clean(name)
      name.to_s.delete('@').to_sym
    end
  end

  class VarAssignment
    attr_reader :name, :type, :body

    def initialize(code, diver)
      parts = code.to_a

      @name = SaveManager.clean(parts.first)
      @body = parts.last
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
end
