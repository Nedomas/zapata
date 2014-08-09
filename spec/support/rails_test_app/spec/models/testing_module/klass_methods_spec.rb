require 'rails_helper'

describe TestingModule::KlassMethods do
  let(:klass_methods) do
    TestingModule::KlassMethods.new
  end

  it '#defined_with_self' do
    expect(TestingModule::KlassMethods.defined_with_self(5)).to eq(5)
  end

  it '#defined_with_back_back_self' do
    expect(TestingModule::KlassMethods.defined_with_back_back_self(5)).to eq(5)
  end
end
