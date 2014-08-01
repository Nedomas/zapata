require 'spec_helper'

describe PersonSpec do
  
  let(:person) { Person.new() }
  
  describe '#initialize' do
    expect(@person.initialize('UNSURE_LVAR_name', 'NEVER_SET_shop_id')).to eq()
  end
  
  describe '#show_shop_ids' do
    expect(@person.show_shop_ids).to eq()
  end
  
  describe '#show_name_with_prefix' do
    expect(@person.show_name_with_prefix('funky')).to eq()
  end
  
  describe '#whats_my_code' do
    expect(@person.whats_my_code(:some_code)).to eq()
  end
  
end
