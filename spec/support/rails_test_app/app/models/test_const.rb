class TestConst
  def initialize
  end

  def test_const_in_arg(const)
    const
  end

  private

  def data_to_analyze
    const = TestConst
  end
end
