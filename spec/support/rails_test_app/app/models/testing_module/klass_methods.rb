module TestingModule
  class KlassMethods
    def self.defined_with_self(klass_methods_int)
      klass_methods_int
    end

    class << self
      def defined_with_back_back_self(klass_methods_int)
        klass_methods_int
      end
    end

    private

    class << self
      def privately_defined_with_back_back_self(klass_methods_int)
        klass_methods_int
      end
    end

    def self.privately_defined_with_self(klass_methods_int)
      klass_methods_int
    end

    def data_to_analyze
      klass_methods_int = 5
    end
  end
end
