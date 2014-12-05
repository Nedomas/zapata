require 'spec_helper'

describe Zapata::Revolutionist do
  describe '#generate_with_friendly_output' do
    let(:file_name) { 'app/models/test_array.rb' }

    context "with the generate command" do
      context 'with single specified' do
        it 'returns a single file generation message' do
          output = execution_output("cd #{RAILS_TEST_APP_DIR} && bundle exec zapata generate #{file_name} -s")
          expect(output.count).to eq 1
          expect(output.first).to eq "Its done, comrades. File spec/models/test_array_spec.rb was generated.\n"
        end
      end

      context 'with no single specified' do
        it 'returns mulptile files generation messages' do
          output = execution_output("cd #{RAILS_TEST_APP_DIR} && bundle exec zapata generate #{file_name}")
          expect(output.count).to be > 1
        end
      end
    end

    context "without the generate command" do
      context 'with single (-s) specified' do
        it 'returns a single file generation message' do
          output = execution_output("cd #{RAILS_TEST_APP_DIR} && bundle exec zapata #{file_name} -s")
          expect(output.count).to eq 1
          expect(output.first).to eq "Its done, comrades. File spec/models/test_array_spec.rb was generated.\n"
        end
      end

      context 'with single (--single) specified' do
        it 'returns a single file generation message' do
          output = execution_output("cd #{RAILS_TEST_APP_DIR} && bundle exec zapata #{file_name} --single")
          expect(output.count).to eq 1
          expect(output.first).to eq "Its done, comrades. File spec/models/test_array_spec.rb was generated.\n"
        end
      end

      context 'with no single specified' do
        it 'returns multiple file generation messages' do
          output = execution_output("cd #{RAILS_TEST_APP_DIR} && bundle exec zapata #{file_name}")
          expect(output.count).to be > 1
        end
      end
    end

    def execution_output(command)
      stdout = Bundler.with_clean_env do
        Open3.pipeline_r(
          command
        )
      end
      stdout.first.readlines
    end
  end
end
