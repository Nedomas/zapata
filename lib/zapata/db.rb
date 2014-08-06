module Zapata
  class DB
    @records = []

    class << self
      def create(record)
        @records << record
        record
      end

      def all
        @records
      end

      def destroy_all
        @records = []
      end

      def get
        binding.pry
      end
    end
  end

  class SaveManager
    def self.clean(name)
      name.to_s.delete('@').to_sym
    end
  end
end
