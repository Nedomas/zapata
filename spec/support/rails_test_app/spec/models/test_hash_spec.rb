require 'rails_helper'

describe TestHash do
  let(:test_hash) do
    TestHash.new
  end

  it '#test_hash_in_arg' do
    expect(test_hash.test_hash_in_arg({ 1 => :one, 2 => :two })).to eq({1=>:one, 2=>:two})
  end
end
