module Zapata
  class RSpecRunner
    def initialize(spec_filename)
      @spec_filename = spec_filename
      configure
      run
    end

    def methodz
      output[:examples].index_by { |ex| ex[:description].delete('#').to_sym }
    end

    def output
      @json_formatter.output_hash
    end

    def configure
      RSpec.configure do |c|
        c.add_formatter(:json)
      end

      config = RSpec.configuration

      # optionally set the console output to colourful
      # equivalent to set --color in .rspec file
      config.color = true

      # using the output to create a formatter
      # documentation formatter is one of the default rspec formatter options
      @json_formatter = RSpec::Core::Formatters::JsonFormatter.new(config.output)

      # set up the reporter with this formatter
      reporter =  RSpec::Core::Reporter.new(@json_formatter)
      config.instance_variable_set(:@reporter, reporter)
    end

    def run
      RSpec::Core::Runner.run([@spec_filename])
    end
  end
end
