require 'rails_helper'

describe TestFloat do
  let(:test_float) do
    TestFloat.new
  end

  it '#test_float_in_arg' do
    expect(test_float.test_float_in_arg(2.718)).to eq(2.718)
  end
end
