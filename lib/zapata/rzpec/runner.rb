module Zapata
  module RZpec
    class Runner
      attr_reader :ran

      def initialize(spec_filename)
        @spec_filename = spec_filename
        run
        # silence { run }
      end

      def silence
        original_stderr = $stderr.dup
        original_stdout = $stdout.dup

        $stdout.reopen('/dev/null', 'w')
        $stdout.reopen('/dev/null', 'w')

        yield

        $stderr = original_stderr
        $stdout = original_stdout
      end

      def methodz
        examples.index_by { |ex| ex['description'].delete('#').to_sym }
      end

      def result_message(method_name)
        methodz[method_name]['exception']['message']
      end

      def expected(method_name)
        report_lines = result_message(method_name).to_s.split(/\n/)
        expected_line = report_lines.detect { |line| line.match('got:') }

        if expected_line
          clean_expected_line = expected_line[10..-1]

          if (matches = clean_expected_line.match(/\#\<(.+):(.+)\>/))
            "'Returned instance object #{matches[1]}'"
          else
            Printer.print(Diver.dive(Parser::CurrentRuby.parse(clean_expected_line)).to_raw)
          end
        else
          "'Exception in RSpec'"
        end
      end

      def run
        @ran = true

        @stdin, @stdout, @stderr = Bundler.with_clean_env do
          Open3.popen3("bundle exec rspec #{@spec_filename} --format j")
        end
      end

      def examples
        parsed_json_result['examples']
      end

      def parsed_json_result
        @json ||= JSON.parse(@stdout.readlines.last)
      end
    end
  end
end
