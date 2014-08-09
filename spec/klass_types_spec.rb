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

    context 'klass methods' do
      before(:all) do
        @generated = exec_generation('app/models/testing_module/klass_methods.rb')
      end

      it '#defined_with_self' do
        has_block('#defined_with_self', %Q{
          expect(TestingModule::KlassMethods.defined_with_self(5)).to eq(5)
        })
      end

      it '#defined_with_back_back_self' do
        has_block('#defined_with_back_back_self', %Q{
          expect(TestingModule::KlassMethods.defined_with_back_back_self(5)).to eq(5)
        })
      end
    end
  end
end
