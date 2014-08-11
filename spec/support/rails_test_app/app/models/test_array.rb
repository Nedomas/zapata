class TestArray
  def initialize
  end

  def test_in_arg(numbers_array)
    numbers_array
  end

  def test_nested_one_level(nested_one_level)
    nested_one_level
  end

  def test_nested_two_levels(nested_two_levels)
    nested_two_levels
  end

  def test_nested_three_levels(nested_three_levels)
    nested_three_levels
  end

  def test_hash_nested(hash_nested)
    hash_nested
  end

  private

  def data_to_analyze
    numbers_array = [2, 7.1, 8]
    nested_one_level = [numbers_array, :mexico]
    nested_two_levels = [nested_one_level, numbers_array, :mexico]
    nested_three_levels = [nested_two_levels, nested_one_level, numbers_array, :mexico]
    hash_nested = [{ emiliano: numbers_array }]
  end
end
