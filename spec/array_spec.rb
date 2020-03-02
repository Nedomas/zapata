describe Zapata::Revolutionist do
  before(:all) do
    @generated = exec_generation('app/models/test_array.rb')
  end

  it '#test_in_arg' do
    has_block('#test_in_arg', %{
      expect(test_array.test_in_arg([2, 7.1, 8])).to eq([2, 7.1, 8])
    })
  end

  it '#test_nested_one_level' do
    has_block('#test_nested_one_level', %{
      expect(test_array.test_nested_one_level([[2, 7.1, 8], :mexico])).to eq([[2, 7.1, 8], :mexico])
    })
  end

  it '#test_nested_two_levels' do
    has_block('#test_nested_two_levels', %{
      expect(test_array.test_nested_two_levels([[[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico])).to eq([[[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico])
    })
  end

  it '#test_nested_three_levels' do
    has_block('#test_nested_three_levels', %{
      expect(test_array.test_nested_three_levels([[[[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico], [[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico])).to eq([[[[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico], [[2, 7.1, 8], :mexico], [2, 7.1, 8], :mexico])
    })
  end

  it '#test_hash_nested' do
    has_block('#test_hash_nested', %{
      expect(test_array.test_hash_nested([{ emiliano: [2, 7.1, 8] }])).to eq([{ emiliano: [2, 7.1, 8] }])
    })
  end
end
