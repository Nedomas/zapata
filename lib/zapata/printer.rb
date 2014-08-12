module Zapata
  class Printer
    class << self
      def print(raw)
        case raw.type
        when :const, :send, :int, :const_send, :literal, :float
          raw.value
        when :str
          # decide which one to use
          # "\"#{raw.value}\""
          "'#{raw.value}'"
        when :sym
          ":#{raw.value}"
        when :true
          true
        when :false
          false
        when :array
          array(raw.value)
        when :hash
          hash(raw.value)
        when :nil
          'nil'
        when :missing
          print(Primitive::Raw.new(:str, "Missing \"#{raw.value}\""))
        when :ivar
          RZpec::Writer.ivars << raw
          to_var_name(raw.value)
        else
          raise "Not yet implemented #{raw}"
        end
      end

      def array(given_array)
        unnested_array = given_array.map { |el| unnest(el) }
        "[#{unnested_array.join(', ')}]"
      end

      def args(given_args, type)
        return unless given_args.present?

        if type == :array
          array_without_closers = given_args[1...-1]
          return unless array_without_closers.present?

          "(#{array_without_closers})"
        elsif %i(int sym hash).include?(type)
          "(#{given_args})"
        elsif %i(nil).include?(type)
          ''
        else
          raise "Not yet implemented"
        end
      end

      def hash(obj)
        unnested_hash = obj.each_with_object({}) do |(key, val), obj|
          unnested_key = unnest(key)
          unnested_val = unnest(val)
          obj[unnested_key] = unnested_val
        end

        all_keys_symbols = unnested_hash.keys.all? do |key|
          Parser::CurrentRuby.parse(key.to_s).type == :sym
        end

        values = unnested_hash.map do |key, val|
          if all_keys_symbols
            "#{key[1..-1]}: #{val}"
          else
            "#{key} => #{val}"
          end
        end

        "{ #{values.join(', ')} }"
      end

      def unnest(raw)
        return raw unless raw.respond_to?(:value)

        if raw.value.is_a?(Primitive::Raw)
          print(unnest(raw.value))
        else
          print(raw)
        end
      end

      def to_var_name(name)
        name.to_s.split('::').last.underscore.delete('@')
      end
    end
  end
end
