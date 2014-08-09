require 'rails_helper'

describe TestInt do
  let(:test_int) do
    TestInt.new
  end

  it '#test_int_in_arg' do
    expect(test_int.test_int_in_arg(1)).to eq(1)
  end
end
