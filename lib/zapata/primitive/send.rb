# frozen_string_literal: true

module Zapata
  module Primitive
    class Send < Base
      def initialize(code)
        super

        if node.name == :private
          Diver.access_level = :private
        elsif node.name == :protected
          Diver.access_level = :protected
        elsif node.name == :public
          Diver.access_level = :public
        end
      end

      def to_a
        [value]
      end

      def node
        receiver, name, args = @code.to_a
        type = @code.type
        OpenStruct.new(type: type, name: name, args: args, receiver: receiver)
      end

      def raw_receiver
        return unless node.receiver

        Diver.dive(node.receiver).to_raw
      end

      def to_raw
        if raw_receiver && raw_receiver.type == :const
          ConstSend.new(raw_receiver, node.name, node.args).to_raw
        else
          missing_name = if node.receiver
            Unparser.unparse(code)
          else
            node.name
          end

          Missing.new(missing_name).to_raw
        end
      end
    end
  end
end
