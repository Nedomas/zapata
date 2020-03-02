require 'parser/current'
require 'unparser'
require 'rails'
require 'require_all'
require 'file/temp'
require 'open3'
require 'rspec'
require 'memoist'

require_rel 'zapata/core'
require_rel 'zapata/predictor'
require_rel 'zapata/primitive/base'
require_rel 'zapata/primitive'
require_rel 'zapata/rzpec'
require_relative 'zapata/analyst'
require_relative 'zapata/diver'
require_relative 'zapata/db'
require_relative 'zapata/printer'
require_relative 'zapata/version'

module Zapata
  class Revolutionist
    class << self
      attr_accessor :analysis, :analysis_as_array

      def generate_with_friendly_output(filename:, single: false)
        spec_filename = Zapata::Revolutionist.generate(filename: filename, single: single)
        puts "Its done, comrades. File #{spec_filename} was generated."
      end

      def generate(filename:, single: false)
        dirs = single ? [] : %w(app/models)
        file_list = Core::Collector.expand_dirs_to_files(dirs)
        new(file_list).generate_rspec_for(filename, spec_filename(filename))
      end

      def init_analysis_as_array
        @analysis_as_array = analysis.values.flatten
      end

      def spec_filename(filename)
        filename.gsub('app/', 'spec/').gsub('.rb', '_spec.rb')
      end

      private

      def single?(opts, args)
        opts.single? || args.include?('-s') || args.include?('--single')
      end
    end

    def initialize(file_list)
      Core::Loader.load_spec_helper
      self.class.analysis = analyze_multiple(file_list)
    end

    def analyze_multiple(files)
      total = files.size.to_s

      files.each_with_object({}).with_index do |(filename, obj), i|
        puts "[#{adjusted_current(i, total)}/#{total}] Analyzing: #{filename}"
        obj[filename] = Analyst.analyze(filename)
      end
    end

    def adjusted_current(i, total)
      (i + 1).to_s.rjust(total.size)
    end

    def generate_rspec_for(filename, spec_filename)
      unless self.class.analysis[filename]
        self.class.analysis[filename] = Analyst.analyze(filename)
      end

      self.class.init_analysis_as_array

      code = Core::Reader.parse(filename)

      global_analysis = Revolutionist.analysis_as_array
      # first run
      tmp_spec_filename = File::Temp.new(false).path
      RZpec::Writer.new(tmp_spec_filename, code, self.class.analysis[filename], global_analysis)

      save_spec_file(tmp_spec_filename, spec_filename)
      spec_analysis = RZpec::Runner.new(spec_filename)

      # second run with RSpec results
      RZpec::Writer.new(tmp_spec_filename, code, self.class.analysis[filename], global_analysis, spec_analysis)
      save_spec_file(tmp_spec_filename, spec_filename)
    end

    def save_spec_file(tmp_spec_filename, spec_filename)
      spec_path = "#{Dir.pwd}/#{spec_filename}"
      spec_dir = spec_path.split('/')[0...-1].join('/')
      FileUtils.mkdir_p(spec_dir)
      FileUtils.cp(tmp_spec_filename, spec_path)
      spec_filename
    end
  end
end
