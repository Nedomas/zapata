# frozen_string_literal: true

require 'coveralls'

Coveralls.wear!

require 'zapata'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Helper methods
RAILS_TEST_APP_DIR = "#{Dir.pwd}/spec/support/rails_test_app"

def execution_output(command)
  stdout = Bundler.with_clean_env do
    Open3.pipeline_r(
      command
    )
  end
  stdout.first.readlines
end

def clean(string)
  string.split(/\n/).map(&:strip).join("\n")
end

def expected(code)
  clean(
    <<-EXPECTED
      #{code}
    EXPECTED
  )
end

def exec_generation(generate_for)
  _, stdout, stderr = Bundler.with_clean_env do
    Open3.popen3(
      "cd #{RAILS_TEST_APP_DIR} && bundle exec zapata generate #{generate_for} -s"
    )
  end

  output = stdout.readlines
  begin
    generated_filename = output.last.match(/File\ (.+)\ was/)[1]
  rescue StandardError
    raise "Did not get the message that file was generated. Got this instead:
      STDOUT: #{output}
      STDERR: #{stderr.readlines}"
  end
  spec_path = "#{RAILS_TEST_APP_DIR}/#{generated_filename}"

  clean(
    <<-ACTUAL
      #{File.read(spec_path)}
    ACTUAL
  )
end

def has_block(name, expected_content)
  generated_lines = @generated.split("\n")
  it_starts = generated_lines.index { |line| line == "it '#{name}' do" }
  raise 'No such block' unless it_starts

  might_match_lines = generated_lines[it_starts..-1]
  it_ends = might_match_lines.index { |line| line == 'end' }

  block = might_match_lines[1...it_ends].first
  expect(block).to eq(expected_content.strip)
end
