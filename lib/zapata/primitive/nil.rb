# frozen_string_literal: true

module Zapata
  module Primitive
    class Nil < Basic
      def initialize
      end

      def node
        OpenStruct.new(type: :nil)
      end

      def to_raw
        Raw.new(:nil, nil)
      end
    end
  end
end
