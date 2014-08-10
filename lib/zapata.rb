require 'parser/current'
require 'unparser'
require 'pry'
require 'pry-stack_explorer'
require 'rails'
require 'require_all'
require 'file/temp'
require 'open3'

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
    class << self
      attr_accessor :analysis

      def generate(filename)
        dirs = %w(app/models app/controllers)
        file_list = Core::Collector.expand_dirs_to_files(dirs)

        # files = %w(app/models/actual_fragment.rb app/models/ical.rb app/models/calendar/balance_transfer.rb)

        new(file_list).generate_rspec_for(filename, spec_filename(filename))
      end

      def analysis_as_array
        analysis.values.flatten
      end

      def spec_filename(filename)
        filename.gsub('app/', 'spec/').gsub('.rb', '_spec.rb')
      end
    end

    def initialize(file_list)
      Core::Loader.load_spec_helper
      self.class.analysis = analyze_multiple(file_list)
    end

    def analyze_multiple(files)
      files.each_with_object({}) do |filename, obj|
        puts "Analyzing: #{filename}"
        obj[filename] = Analyst.analyze(filename)
      end
    end

    def generate_rspec_for(filename, spec_filename)
      self.class.analysis[filename] = Analyst.analyze(filename) unless self.class.analysis[filename]

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
