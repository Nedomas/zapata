require 'parser/current'
require 'pry'
require 'pry-stack_explorer'
require 'andand'
require_relative 'zapata/analyst'
require_relative 'zapata/version'
require_relative 'zapata/var_collector'
require_relative 'zapata/rspec_writer'
require_relative 'zapata/writer'
require_relative 'zapata/code_parser'
require_relative 'zapata/file_collector'
require_relative 'zapata/missing_variable'

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
      RspecWriter.new(filename, code, merged_analysis).result
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

dirs = %w(app/models app/controllers)
file_list = Zapata::FileCollector.expand_dirs_to_files(dirs)

Zapata::Revolutionist.new(file_list)
  .generate_rspec_for('app/models/class_to_test.rb')
puts 'Its done, comrades'
