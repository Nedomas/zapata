class TestDefinition
  def in_optional_args(optional = :audioslave)
    optional
  end

  def use_optional(optional)
    optional
  end

  def var_in_optional_args(optional_var = fallback)
    optional_var
  end

  def method_in_optional_args(optional_method = fall_meth)
    optional_method
  end

  def call_method_result_in_optional_args(complex_method = fall_meth.first)
    complex_method
  end

  def should_not_show_empty_method
  end

  def recursive_method
    recursive_method
  end

  private

  def fall_meth
    'I am falling'
  end

  def data_to_analyze
    fallback = 'Chuck'
  end
end
