module Zapata
  module Primitive
    class Arg < Basic
      def name
        @body = [nil] unless @body

        @body.to_a.first
      end
    end
  end
end
