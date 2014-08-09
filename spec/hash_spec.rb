require 'spec_helper'

describe Zapata::Revolutionist do
  it 'hash should work with various methods' do
    generated = exec_generation('app/models/test_hash.rb')
    expected = expected(%Q{require 'rails_helper'

    describe TestHash do
      let(:test_hash) do
        TestHash.new
      end

      it '#test_hash_in_arg' do
        expect(test_hash.test_hash_in_arg({ 1 => :one, 2 => :two })).to eq({1=>:one, 2=>:two})
      end
    end})

    expect(generated).to eq(expected)
  end
end
