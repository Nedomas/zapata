module Zapata
  class DB
    @records = []
    @locs = []

    class << self
      def create(record)
        loc = record.code.loc

        unless @locs.include?(loc)
          @records << record
          @locs << loc
          record
        end
      end

      def all
        @records
      end

      def destroy_all
        @records = []
      end
    end
  end

  class SaveManager
    def self.clean(name)
      name.to_s.delete('@').to_sym
    end
  end
end
