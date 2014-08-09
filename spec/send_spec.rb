require 'spec_helper'

describe Zapata::Revolutionist do
  before(:all) do
    @generated = exec_generation('app/models/test_send.rb')
  end

  it '#another_method_as_arg' do
    has_block('#another_method_as_arg', %Q{
      expect(test_send.another_method_as_arg('Help method')).to eq('Help method')
    })
  end

  it '#second_level_method_chain' do
    has_block('#second_level_method_chain', %Q{
      expect(test_send.second_level_method_chain('Help method')).to eq('Help method')
    })
  end

  it '#third_level_method_chain' do
    has_block('#third_level_method_chain', %Q{
      expect(test_send.third_level_method_chain('Help method')).to eq('Help method')
    })
  end

  it '#method_with_calculated_value' do
    has_block('#method_with_calculated_value', %Q{
      expect(test_send.method_with_calculated_value('Missing "calculated_value"')).to eq('Missing "calculated_value"')
    })
  end
end
