module Zapata
  module Primitive
    class Klass < Basic
#       attr_reader :body, :name
#       attr_accessor :args_to_s
#
#       def initialize(name_node, inherited_from_klass, body)
#         @body = body
#         @module, @name = name_node.to_a
#       end
#
#       def initialized?
#         @args_to_s
#       end
#
#       def initialize_to_s
#         "#{@name}.new#{@args_to_s}"
#       end
#
#       def new
#         eval(initialize_to_s)
#       end
      def name
        binding.pry
      end
    end
  end
end
