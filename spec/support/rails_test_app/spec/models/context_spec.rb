require 'rails_helper'

describe Context do

  let(:context) do
    Context.new(OpenStruct.new(user: 123))
  end

  it '#user' do
    expect(context.user).to eq('FILL IN THIS BY HAND')
  end

end
