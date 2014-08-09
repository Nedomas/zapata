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

  def to_another_object(another_object_method)
    another_object_method
  end

  def to_another_object_with_params(send_with_params)
    send_with_params
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

  def data_to_analyze
    another_object_method = AnotherObject.my_name
  end
end

class AnotherObject
  def self.my_name
    'Domas'
  end

  def self.send_with_params(id)
    "Id was #{id}"
  end
end
