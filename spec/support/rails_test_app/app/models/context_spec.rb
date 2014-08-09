require 'rails_helper'

describe Context do

  let(:context) do
    Context.new('Missing "deep_dive"')
  end

  it '#user' do
    expect(context.user()).to eq('FILL IN THIS BY HAND')
  end

end
