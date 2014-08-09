require 'rails_helper'

describe TestSimpleArgumentTypes do

  let(:test_simple_argument_types) do
    TestSimpleArgumentTypes.new(1)
  end

  it '#test_int' do
    expect(test_simple_argument_types.test_int(1)).to eq(1)
  end

end
