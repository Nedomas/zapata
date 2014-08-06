module Zapata
  module File
    class Collector
      def self.expand_dirs_to_files(dirs)
        dirs.map { |dir| Dir["#{dir}/*.rb"] }.flatten
      end
    end
  end
end
