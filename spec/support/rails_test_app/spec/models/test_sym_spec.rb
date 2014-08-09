require 'rails_helper'

describe TestSym do
  let(:test_sym) do
    TestSym.new
  end

  it '#test_sym_in_arg' do
    expect(test_sym.test_sym_in_arg(:rock)).to eq(:rock)
  end
end
