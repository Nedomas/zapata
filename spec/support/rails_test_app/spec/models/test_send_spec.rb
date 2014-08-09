require 'rails_helper'

describe TestSend do
  let(:test_send) do
    TestSend.new
  end

  it '#another_method_as_arg' do
    expect(test_send.another_method_as_arg('Help method')).to eq('Fill this in by hand')
  end

  it '#second_level_method_chain' do
    expect(test_send.second_level_method_chain('Help method')).to eq('Fill this in by hand')
  end

  it '#third_level_method_chain' do
    expect(test_send.third_level_method_chain('Help method')).to eq('Fill this in by hand')
  end

  it '#method_with_calculated_value' do
    expect(test_send.method_with_calculated_value('Missing "calculated_value"')).to eq('Fill this in by hand')
  end
end
