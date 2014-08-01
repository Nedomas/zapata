class Person
  def initialize(name, shop_id)
    @name = name
    @shop_ids = shop_ids
  end

  def show_shop_ids
    p @shop_ids
  end
end

module City
  class Shop
    class << self
      def person_names
        %w(John Peter)
      end
    end
  end

  class Area
    def initialize(shop_ids)
      @shop_ids = shop_ids
    end

    def randomize_shop_ids
      @shop_ids = [1, 2, 3]
    end
  end
end
