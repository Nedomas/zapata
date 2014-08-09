class TestHash
  def initialize
  end

  def test_in_arg(hash)
    hash
  end

  def test_nested_one_level(one_level_nested_hash)
    one_level_nested_hash
  end

  def test_nested_two_levels(two_levels_nested_hash)
    two_levels_nested_hash
  end

  def test_nested_three_levels(three_levels_nested_hash)
    three_levels_nested_hash
  end

  def test_key_as_another_hash(key_as_another_hash)
    key_as_another_hash
  end

  def test_keys_are_symbols(pretty_hash)
    pretty_hash
  end

  private

  def data_to_analyze
    hash = { 1 => :one, TestHash => 2.718 }
    one_level_nested_hash = { first_level: hash }
    two_levels_nested_hash = { second_level: one_level_nested_hash }
    three_levels_nested_hash = { third_level: two_levels_nested_hash }
    key_as_another_hash = { hash => :ratm }
    pretty_hash = { this: 'should', be: 'pretty' }
  end
end
