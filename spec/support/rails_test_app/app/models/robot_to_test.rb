class RobotToTest
  attr_accessor :name

  def initialize
    run_helping_method = some_helping_method
  end

  def some_helping_method
    'hello'
  end

  def test_method_return_as_arg(run_helping_method)
    run_helping_method
  end
end
