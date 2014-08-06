module Zapata
  module Primitive
    class Klass < Base
        # @instance = InstanceMock.new(name, inherited_from_klass, body)
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
      def node
        const, inherited_from_klass, body = @code.to_a
        modul, name = const.to_a
        type = @code.type

        OpenStruct.new(type: type, modul: modul, name: name, body: body)
      end
    end
  end
end
