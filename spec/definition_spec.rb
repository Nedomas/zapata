require 'spec_helper'

describe Zapata::Revolutionist do
  before(:all) do
    @generated = exec_generation('app/models/test_definition.rb')
  end

  it '#test_in_arg' do
    has_block('#test_in_arg', %Q{
      expect(test_hash.test_in_arg({ 1 => :one, TestHash => 2.718 })).to eq({ 1 => :one, TestHash => 2.718 })
    })
  end
end
