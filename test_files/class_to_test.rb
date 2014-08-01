class Person < Object
  def initialize(name, shop_id)
    @name = name
    @shop_ids = shop_ids
    @code = :some_code
    @prefix = 'funky'
    show_name_with_prefix(prefix)
  end

  def show_shop_ids
    Hello.p @shop_ids
  end

  def show_name_with_prefix(prefix)
    "#{prefix}_#{@name}"
  end

  def whats_my_code(code)
    code
  end
end
