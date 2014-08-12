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

  it '#to_another_object' do
    has_block('#to_another_object', %Q{
      expect(test_send.to_another_object(AnotherObject.my_name)).to eq('Domas')
    })
  end

  it '#to_another_object_with_params' do
    has_block('#to_another_object_with_params', %Q{
      expect(test_send.to_another_object_with_params(AnotherObject.send_with_params(12))).to eq('Id was 12')
    })
  end

  it '#not_explicit_with_params' do
    has_block('#not_explicit_with_params', %Q{
      expect(test_send.not_explicit_with_params('Could you find it?')).to eq('Could you find it?')
    })
  end

  it '#fail_to_understand' do
    has_block('#fail_to_understand', %Q{
      expect(test_send.fail_to_understand('Missing "failure"')).to eq('Missing "failure"')
    })
  end
end
