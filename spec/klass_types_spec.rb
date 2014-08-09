require 'spec_helper'

describe Zapata::Revolutionist do
  context 'it should work with' do
    it 'bare module' do
      generated = exec_generation('app/models/testing_module/bare.rb')
      expected = expected(%Q{require 'rails_helper'

      describe TestingModule::Bare do
        let(:bare) do
          TestingModule::Bare.new
        end
      end})

      expect(generated).to eq(expected)
    end

    it 'nested module' do
      generated = exec_generation('app/models/testing_module/nested/inside.rb')
      expected = expected(%Q{require 'rails_helper'

      describe TestingModule::Nested::Inside do
        let(:inside) do
          TestingModule::Nested::Inside.new
        end
      end})

      expect(generated).to eq(expected)
    end
  end
end
