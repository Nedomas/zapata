require 'spec_helper'

describe Zapata::Revolutionist do
  it 'arrays' do
    generated = exec_generation('app/models/test_array.rb')
    expected = expected(%Q{require 'rails_helper'

    describe TestArray do
      let(:test_array) do
        TestArray.new
      end

      it '#test_in_arg' do
        expect(test_array.test_in_arg([2, 7.1, 8])).to eq([2, 7.1, 8])
      end

      it '#test_nested_one_level' do
        expect(test_array.test_nested_one_level([[2, 7.1, 8], :mexico])).to eq([[2, 7.1, 8], :mexico])
      end

      it '#test_nested_two_levels' do
        expect(test_array.test_nested_two_levels([[[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico])).to eq([[[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico])
      end

      it '#test_nested_three_levels' do
        expect(test_array.test_nested_three_levels([[[[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico], [[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico])).to eq([[[[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico], [[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico])
      end

      it '#test_hash_nested' do
        expect(test_array.test_hash_nested([{ emiliano: [2, 7.1, 8] }])).to eq([{ emiliano: [2, 7.1, 8] }])
      end
    end})

    expect(generated).to eq(expected)
  end
end
