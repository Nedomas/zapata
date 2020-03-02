# frozen_string_literal: true

module Zapata
  module Core
    class Collector
      def self.expand_dirs_to_files(dirs)
        dirs.map { |dir| Dir["#{dir}/*.rb"] }.flatten
      end
    end
  end
end
