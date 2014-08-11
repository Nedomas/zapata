require 'spec_helper'

describe Zapata::Revolutionist do
  before(:all) do
    @generated = exec_generation('app/models/test_definition.rb')
  end

  it '#in_optional_args' do
    has_block('#in_optional_args', %Q{
      expect(test_definition.in_optional_args(:audioslave)).to eq(:audioslave)
    })
  end

  it '#use_optional' do
    has_block('#use_optional', %Q{
      expect(test_definition.use_optional(:audioslave)).to eq(:audioslave)
    })
  end

  it '#var_in_optional_args' do
    has_block('#var_in_optional_args', %Q{
      expect(test_definition.var_in_optional_args('Chuck')).to eq('Chuck')
    })
  end

  it '#method_in_optional_args' do
    has_block('#method_in_optional_args', %Q{
      expect(test_definition.method_in_optional_args('I am falling')).to eq('I am falling')
    })
  end

  it '#call_method_result_in_optional_args' do
    has_block('#call_method_result_in_optional_args', %Q{
      expect(test_definition.call_method_result_in_optional_args('Missing "complex_method"')).to eq('Missing "complex_method"')
    })
  end

  it '#resursive_method' do
    has_block('#recursive_method', %Q{
      expect(test_definition.recursive_method).to eq('Exception in RSpec')
    })
  end
end
