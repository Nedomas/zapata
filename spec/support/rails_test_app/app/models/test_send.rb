class TestSend
  def another_method_as_arg(help_method)
    help_method
  end

  def second_level_method_chain(second_level_method)
    second_level_method
  end

  def third_level_method_chain(third_level_method)
    third_level_method
  end

  def method_with_calculated_value(calculated_value)
    calculated_value
  end

  private

  def help_method
    'Help method'
  end

  def second_level_method
    help_method
  end

  def third_level_method
    second_level_method
  end

  def calculated_value
    1 + 3
  end
end
