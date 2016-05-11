require 'rails_helper'

describe TestHash do
  let(:test_hash) do
    TestHash.new
  end

  it '#test_in_arg' do
    expect(test_hash.test_in_arg(1 => :one, TestHash => 2.718)).to eq(1 => :one, TestHash => 2.718)
  end

  it '#test_nested_one_level' do
    expect(test_hash.test_nested_one_level(first_level: { 1 => :one, TestHash => 2.718 })).to eq(first_level: { 1 => :one, TestHash => 2.718 })
  end

  it '#test_nested_two_levels' do
    expect(test_hash.test_nested_two_levels(second_level: { first_level: { 1 => :one, TestHash => 2.718 } })).to eq(second_level: { first_level: { 1 => :one, TestHash => 2.718 } })
  end

  it '#test_nested_three_levels' do
    expect(test_hash.test_nested_three_levels(third_level: { second_level: { first_level: { 1 => :one, TestHash => 2.718 } } })).to eq(third_level: { second_level: { first_level: { 1 => :one, TestHash => 2.718 } } })
  end

  it '#test_key_as_another_hash' do
    expect(test_hash.test_key_as_another_hash({ 1 => :one, TestHash => 2.718 } => :ratm)).to eq({ 1 => :one, TestHash => 2.718 } => :ratm)
  end

  it '#test_keys_are_symbols' do
    expect(test_hash.test_keys_are_symbols(this: 'should', be: 'pretty')).to eq(this: 'should', be: 'pretty')
  end
end
