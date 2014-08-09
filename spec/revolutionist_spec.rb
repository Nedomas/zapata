require 'spec_helper'
require 'open3'


describe Zapata::Revolutionist do
  it 'should work with ints' do
    generate_for = 'app/models/test_int.rb'
    spec_path = exec_generation(generate_for)
    generated = clean(File.read(spec_path))
    generated = <<-ACTUAL
    #{File.read(spec_path)}
    ACTUAL

    expected = <<-EXPECTED
      require 'rails_helper'

      describe TestInt do

        let(:test_int) do
          TestInt.new
        end

        it '#test_int_in_arg' do
          expect(test_int.test_int_in_arg(1)).to eq(1)
        end

      end
    EXPECTED

    expect(clean(generated)).to eq(clean(expected))
  end
end

RAILS_TEST_APP_DIR = "#{Dir.pwd}/spec/support/rails_test_app"

def clean(string)
  string.split(/\n/).map(&:strip).join("\n")
end

def exec_generation(generate_for)
  stdin, stdout, stderr = Bundler.with_clean_env do
    Open3.popen3(
      "cd #{RAILS_TEST_APP_DIR} && bundle exec zapata generate #{generate_for}"
    )
  end

  output = stdout.readlines
  generated_filename = output.last.match(/File\ (.+)\ was/)[1]
  "#{RAILS_TEST_APP_DIR}/#{generated_filename}"
end
