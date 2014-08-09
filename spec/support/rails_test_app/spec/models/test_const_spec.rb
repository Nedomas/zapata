require 'rails_helper'

describe TestConst do
  let(:test_const) do
    TestConst.new
  end

  it '#test_const_in_arg' do
    expect(test_const.test_const_in_arg(TestConst)).to eq(TestConst)
  end
end
