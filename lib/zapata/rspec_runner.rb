module Zapata
  class RSpecRunner
    attr_reader :ran

    def initialize(spec_filename)
      @spec_filename = spec_filename
      run
    end

    def methodz
      examples.index_by { |ex| ex.metadata[:description].delete('#').to_sym } rescue binding.pry
    end

    def metadata(method_name)
      methodz[method_name].metadata
    end

    def exception(method_name)
      metadata(method_name)[:execution_result].exception
    end

    def expected(method_name)
      report_lines = exception(method_name).to_s.split(/\n/)
      expected_line = report_lines.detect { |line| line.match('got:') }
      clean_expected_line = expected_line[9..-1]
      eval(clean_expected_line)
    end

    def run
      @ran = true
      RSpec::Core::Runner.run([@spec_filename])
    end

    def examples
      reporter = RSpec.configuration.reporter
      rspec_examples = reporter.instance_variable_get(:@examples)

      raise 'Exception in rspec' unless rspec_examples

      rspec_examples
    end
  end
end
