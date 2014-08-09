require 'rails_helper'

describe TestArray do
  let(:test_array) do
    TestArray.new
  end

  it '#test_array_in_arg' do
    expect(test_array.test_array_in_arg([2, 7.1, 8])).to eq([2, 7.1, 8])
  end
end
