require 'parser/current'
require 'pry'
require 'pry-stack_explorer'
# require 'andand'
require 'rails'
# require 'rspec'
require_relative 'zapata/file'
require_relative 'zapata/predictor'
require_relative 'zapata/primitive'
require_relative 'zapata/rzpec'
require_relative 'zapata/analyst'
require_relative 'zapata/db'
require_relative 'zapata/method_mock'
require_relative 'zapata/object_rebuilder'
require_relative 'zapata/version'

module Zapata
  class Revolutionist
    def initialize(file_list)
      File::Loader.load_spec_helper
      @analysis = analyze_multiple(file_list)
    end

    def analyze_multiple(files)
      files.each_with_object({}) do |filename, obj|
        obj[filename] = Analyst.analyze(filename)
      end
    end

    def generate_rspec_for(filename)
      @analysis[filename] = Analyst.analyze(filename) unless @analysis[filename]

      code = File::Reader.parse(filename)

      # first run
      spec = RZpec::Writer.new(filename, code, @analysis[filename], analysis_as_array)
      spec_analysis = RZpec::Runner.new(spec.spec_filename)

      # second run with RSpec results
      RZpec::Writer.new(filename, code, @analysis[filename], analysis_as_array, spec_analysis)
    end

    def analysis_as_array
      @analysis.values.flatten
    end
  end
end
