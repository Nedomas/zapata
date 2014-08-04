require 'parser/current'
require 'pry'
require 'pry-stack_explorer'
# require 'andand'
require 'rails'
require 'rspec'
require_relative 'zapata/analyst'
require_relative 'zapata/version'
require_relative 'zapata/var_analysis'
require_relative 'zapata/rspec_writer'
require_relative 'zapata/rspec_runner'
require_relative 'zapata/writer'
require_relative 'zapata/code_parser'
require_relative 'zapata/file_collector'
require_relative 'zapata/missing'
require_relative 'zapata/evaluation'
require_relative 'zapata/instance_mock'
require_relative 'zapata/method_mock'
require_relative 'zapata/args_predictor'
require_relative 'zapata/chooser'

# load Rails ENV
require File.expand_path('../../../samesystem/spec/spec_helper',  __FILE__)

module Zapata
  class Revolutionist
    def initialize(file_list)
      @analysis = analyze_multiple(file_list)
    end

    def analyze_multiple(files)
      files.each_with_object({}) do |filename, obj|
        obj[filename] = Analyst.analyze(filename)
      end
    end

    def generate_rspec_for(filename)
      @analysis[filename] = Analyst.analyze(filename) unless @analysis[filename]

      code = CodeParser.parse(filename)

      # first run
      spec = RSpecWriter.new(filename, code, merged_analysis)
      spec_analysis = RSpecRunner.new(spec.spec_filename).methodz

      # second run
      RSpecWriter.new(filename, code, merged_analysis, spec_analysis)
    end

    def merged_analysis
      merge_array_of_hashes(@analysis.values)
    end

    def merge_array_of_hashes(array)
      array.each_with_object({}) do |pairs, obj|
        pairs.each do |k, v|
          (obj[k] ||= []) << v
          obj[k].flatten!
        end
      end
    end
  end
end
