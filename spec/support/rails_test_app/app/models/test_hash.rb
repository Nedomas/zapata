class TestHash
  def initialize
  end

  def test_hash_in_arg(hash)
    hash
  end

  private

  def data_to_analyze
    hash = { 1 => :one, 2 => :two }
  end
end
