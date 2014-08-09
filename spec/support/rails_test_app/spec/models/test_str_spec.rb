require 'rails_helper'

describe TestStr do
  let(:test_str) do
    TestStr.new
  end

  it '#test_str_in_arg' do
    expect(test_str.test_str_in_arg('audioslave')).to eq("audioslave")
  end
end
