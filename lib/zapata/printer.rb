module Zapata
  class Printer
    class << self
      extend Memoist

      def print(raw, args: false)
        type = raw.type

        result = case type
                 when :const, :send, :int, :const_send, :literal, :float
                   raw.value
                 when :str
                   str(raw)
                 when :sym
                   sym(raw)
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
                   missing(raw)
                 when :ivar
                   ivar(raw)
                 else
                   raise "Not yet implemented #{raw}"
        end

        args ? argize(result, type) : result
      end

      def to_var_name(name)
        name.to_s.split('::').last.underscore.delete('@')
      end

      private

      def array(given)
        unnested = given.map { |el| unnest(el) }

        "[#{unnested.join(', ')}]"
      end

      def str(raw)
        # decide which one to use
        # "\"#{raw.value}\""
        "'#{raw.value}'"
      end

      def sym(raw)
        ":#{raw.value}"
      end

      def ivar(raw)
        RZpec::Writer.ivars << raw
        to_var_name(raw.value)
      end

      def missing(raw)
        print(Primitive::Raw.new(:str, "Missing \"#{raw.value}\""))
      end

      def argize(value, type)
        case type
        when :array
          value = value[1...-1]
        when :hash
          value = value[2...-2]
        end

        return unless value.present?

        "(#{[value].flatten.join(', ')})"
      end

      def hash(given)
        unnested = given.each_with_object({}) do |(key, val), obj|
          obj[unnest(key)] = unnest(val)
        end

        values = unnested.map do |key, val|
          print_hash_pair(key, val, all_keys_symbols?(unnested))
        end
        "{ #{values.join(', ')} }"
      end

      def print_hash_pair(key, val, symbol_keys)
        symbol_keys ? "#{key[1..-1]}: #{val}" : "#{key} => #{val}"
      end

      def all_keys_symbols?(hash)
        hash.keys.all? do |key|
          Parser::CurrentRuby.parse(key.to_s).type == :sym
        end
      end
      memoize :all_keys_symbols?

      def unnest(raw)
        return raw unless raw.respond_to?(:value)

        if raw.value.is_a?(Primitive::Raw)
          print(unnest(raw.value))
        else
          print(raw)
        end
      end
    end
  end
end
