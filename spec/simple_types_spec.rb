require 'spec_helper'

describe Zapata::Revolutionist do
  it 'should work with ints' do
    generated = exec_generation('app/models/test_int.rb')
    expected = expected(%Q{require 'rails_helper'

    describe TestInt do
      let(:test_int) do
        TestInt.new
      end

      it '#test_int_in_arg' do
        expect(test_int.test_int_in_arg(1)).to eq(1)
      end
    end})

    expect(generated).to eq(expected)
  end

  it 'should work with symbols' do
    generated = exec_generation('app/models/test_sym.rb')
    expected = expected(%Q{require 'rails_helper'

    describe TestSym do
      let(:test_sym) do
        TestSym.new
      end

      it '#test_sym_in_arg' do
        expect(test_sym.test_sym_in_arg(:rock)).to eq(:rock)
      end
    end})

    expect(generated).to eq(expected)
  end
end
