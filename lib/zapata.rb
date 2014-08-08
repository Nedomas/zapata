require 'parser/current'
require 'unparser'
require 'pry'
require 'pry-stack_explorer'
require 'rails'
require 'require_all'

require_rel 'zapata/core'
require_rel 'zapata/predictor'
require_rel 'zapata/primitive'
require_rel 'zapata/rzpec'
require_relative 'zapata/analyst'
require_relative 'zapata/diver'
require_relative 'zapata/db'
require_relative 'zapata/printer'
require_relative 'zapata/version'

module Zapata
  class Revolutionist
    def initialize(file_list)
      Core::Loader.load_spec_helper
      @@analysis = analyze_multiple(file_list)
    end

    def analyze_multiple(files)
      files.each_with_object({}) do |filename, obj|
        obj[filename] = Analyst.analyze(filename)
      end
    end

    def generate_rspec_for(filename)
      @@analysis[filename] = Analyst.analyze(filename) unless @@analysis[filename]

      code = Core::Reader.parse(filename)

      global_analysis = Revolutionist.analysis_as_array
      # first run
      spec = RZpec::Writer.new(filename, code, @@analysis[filename], global_analysis)
      binding.pry
      spec_analysis = RZpec::Runner.new(spec.spec_filename)

      # second run with RSpec results
      tmp_filename = "#{filename}.tmp"
      RZpec::Writer.new(tmp_filename, code, @@analysis[filename], global_analysis, spec_analysis)
      FileUtils.mv(tmp_filename, filename)
    end

    def self.analysis_as_array
      @@analysis.values.flatten
    end
  end
end
