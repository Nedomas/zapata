module Zapata
  class Chooser
    def initialize(possible_values)
      @possible_values = possible_values.dup
    end

    def by_probability
      return if @possible_values.empty?

      chosen_by_count = by_count

      result = if ArgsPredictor::PRIMITIVE_TYPES.include?(chosen_by_count[:type]) or
        ArgsPredictor::MISSING_TYPES.include?(chosen_by_count[:type])

        chosen_by_count
      else
        @possible_values.delete(chosen_by_count)
        by_probability
      end

      result || chosen_by_count
    end

    private

    def by_count
      group_with_counts(@possible_values).max_by { |_, v| v }.first
    end

    def group_with_counts(values)
      values.each_with_object(Hash.new(0)) do |value, obj|
        obj[value] += 1
      end
    end
  end
end
