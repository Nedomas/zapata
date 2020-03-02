# frozen_string_literal: true

module Zapata
  module Primitive
    class Base
      attr_accessor :code, :type

      def initialize(code)
        @code = code
        @type = code.type
      end

      def name
        SaveManager.clean(node.name)
      end

      def dive_deeper
        unless RETURN_TYPES.include?(node.type)
          Diver.dive(node.args)
          Diver.dive(node.body)
        end
      end

      def to_raw
        Diver.dive(node.body).to_raw
      end

      def return_with_super_as_missing(raw, primitive)
        raw.type == :super ? Missing.new(primitive.name).to_raw : raw
      end

      def return_with_missing_as_super(raw, name)
        raw.type == :missing ? Raw.new(:super, name) : raw
      end
    end
  end
end
