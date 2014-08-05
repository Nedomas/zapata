module Zapata
  class AssignmentRecord
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
end
