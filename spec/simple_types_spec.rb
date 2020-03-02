describe Zapata::Revolutionist do
  context 'it should work with' do
    it 'ints' do
      generated = exec_generation('app/models/test_int.rb')
      expected = expected(%{require 'rails_helper'

      describe TestInt do
        let(:test_int) do
          TestInt.new
        end

        it '#test_int_in_arg' do
          expect(test_int.test_int_in_arg(1)).to eq(1)
        end
      end})

      expect(generated).to eq(expected)
    end

    it 'symbols' do
      generated = exec_generation('app/models/test_sym.rb')
      expected = expected(%{require 'rails_helper'

      describe TestSym do
        let(:test_sym) do
          TestSym.new
        end

        it '#test_sym_in_arg' do
          expect(test_sym.test_sym_in_arg(:rock)).to eq(:rock)
        end
      end})

      expect(generated).to eq(expected)
    end

    it 'strings' do
      generated = exec_generation('app/models/test_str.rb')
      expected = expected(%{require 'rails_helper'

      describe TestStr do
        let(:test_str) do
          TestStr.new
        end

        it '#test_str_in_arg' do
          expect(test_str.test_str_in_arg('audioslave')).to eq('audioslave')
        end
      end})

      expect(generated).to eq(expected)
    end

    it 'floats' do
      generated = exec_generation('app/models/test_float.rb')
      expected = expected(%{require 'rails_helper'

      describe TestFloat do
        let(:test_float) do
          TestFloat.new
        end

        it '#test_float_in_arg' do
          expect(test_float.test_float_in_arg(2.718)).to eq(2.718)
        end
      end})

      expect(generated).to eq(expected)
    end

    it 'consts' do
      generated = exec_generation('app/models/test_const.rb')
      expected = expected(%{require 'rails_helper'

      describe TestConst do
        let(:test_const) do
          TestConst.new
        end

        it '#test_const_in_arg' do
          expect(test_const.test_const_in_arg(TestConst)).to eq(TestConst)
        end
      end})

      expect(generated).to eq(expected)
    end
  end
end
