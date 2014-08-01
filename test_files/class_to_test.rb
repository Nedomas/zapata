class Person < Object
  def initialize(name, shop_id)
    @name = name
    @shop_ids = shop_ids
  end

  def show_shop_ids
    Hello.p @shop_ids
  end
end
