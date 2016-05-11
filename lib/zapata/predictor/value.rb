module Zapata
  module Predictor
    class Value
      extend Memoist

      def initialize(name, finder = nil)
        @name = name
        @finder = finder
      end

      def choose
        return Primitive::Raw.new(:nil, nil) if @name.nil?
        return @finder if @finder && FINAL_TYPES.include?(@finder.type)
        return Primitive::Raw.new(:super, @name) if possible_values.empty?
        Chooser.new(possible_values).by_probability
      end

      def a_finder?(primitive)
        return false unless @finder
        primitive.class == @finder.class && primitive.name == @finder.name
      end

      def possible_values
        Revolutionist.analysis_as_array.select do |element|
          !a_finder?(element) && element.name == @name
        end
      end
      memoize :possible_values
    end
  end
end
