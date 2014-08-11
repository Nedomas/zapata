require 'rails_helper'

describe TestDefinition do
  let(:test_definition) do
    TestDefinition.new
  end

  it '#in_optional_args' do
    expect(test_definition.in_optional_args(:audioslave)).to eq(:audioslave)
  end

  it '#use_optional' do
    expect(test_definition.use_optional(:audioslave)).to eq(:audioslave)
  end

  it '#var_in_optional_args' do
    expect(test_definition.var_in_optional_args('Chuck')).to eq('Chuck')
  end

  it '#method_in_optional_args' do
    expect(test_definition.method_in_optional_args('I am falling')).to eq('I am falling')
  end

  it '#call_method_result_in_optional_args' do
    expect(test_definition.call_method_result_in_optional_args('Missing "complex_method"')).to eq('Missing "complex_method"')
  end

  it '#recursive_method' do
    expect(test_definition.recursive_method).to eq('Exception in RSpec')
  end
end
