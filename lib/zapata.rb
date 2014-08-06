require 'parser/current'
require 'pry'
require 'pry-stack_explorer'
# require 'andand'
require 'rails'
# require 'rspec'
require_relative 'zapata/analyst'
require_relative 'zapata/version'
require_relative 'zapata/var_analysis'
require_relative 'zapata/rspec_writer'
require_relative 'zapata/rspec_runner'
require_relative 'zapata/writer'
require_relative 'zapata/printer'
require_relative 'zapata/code_reader'
require_relative 'zapata/file_collector'
require_relative 'zapata/missing'
require_relative 'zapata/evaluation'
require_relative 'zapata/instance_mock'
require_relative 'zapata/method_mock'
require_relative 'zapata/args_predictor'
require_relative 'zapata/chooser'
require_relative 'zapata/code_diver'
require_relative 'zapata/assignment_record'
require_relative 'zapata/var_assignment'
require_relative 'zapata/def_assignment'
require_relative 'zapata/send'
require_relative 'zapata/primitives'
require_relative 'zapata/object_rebuilder'

module Zapata
  class Revolutionist
    def initialize(file_list)
      load_rails
      @analysis = analyze_multiple(file_list)
    end

    def load_rails
      # load Rails ENV
      rails_dir = Dir.pwd
      rails_helper_path = File.expand_path("#{rails_dir}/spec/rails_helper",  __FILE__)
      spec_helper_path = File.expand_path("#{rails_dir}/spec/spec_helper",  __FILE__)

      @helper_file = if File.exist?("#{rails_helper_path}.rb")
        require rails_helper_path
        'rails_helper'
      elsif File.exist?("#{spec_helper_path}.rb")
        require spec_helper_path
        'spec_helper'
      else
        raise 'Was not able to load nor rails_helper, nor spec_helper'
      end
    end

    def analyze_multiple(files)
      files.each_with_object({}) do |filename, obj|
        obj[filename] = Analyst.analyze(filename)
      end
    end

    def generate_rspec_for(filename)
      @analysis[filename] = Analyst.analyze(filename) unless @analysis[filename]

      code = CodeReader.parse(filename)

      # first run
      spec = RSpecWriter.new(filename, code, @analysis[filename], @helper_file, merged_analysis)
      spec_analysis = RSpecRunner.new(spec.spec_filename)

      # second run
      spec = RSpecWriter.new(filename, code, @analysis[filename], @helper_file, merged_analysis, spec_analysis)
    end

    def merged_analysis
      @analysis.values.flatten
      # Helper.merge_array_of_hashes(@analysis.values) rescue binding.pry
    end
  end

  class Helper
    def self.merge_array_of_hashes(array)
      array.each_with_object({}) do |pairs, obj|
        pairs.each do |k, v|
          (obj[k] ||= []) << v
          obj[k].flatten!
        end
      end
    end
  end
end
