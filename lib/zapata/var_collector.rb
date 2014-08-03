module Zapata
  class VarCollector
    attr_reader :result

    def initialize(code)
      @result = {}

      case code.type
      when :class
        parse_class(code)
      end
    end

    def add_var(name, value)
      clean_name = name.to_s.delete('@').to_sym
      @result[clean_name] ||= []
      @result[clean_name] << value
    end

    def parse_class(class_code)
      klass, inherited_from_klass, body = class_code.to_a
      parse_body(body)
    end

    def parse_body(body)
      case body.type
      when :begin
        parse_block(body)
      when :def
        # single method class
        parse_method(body)
      end
    end

    def parse_block(block)
      case block.type
      when :send
        parse_send(block)
      when :begin
        *parts = block.to_a

        parts.each do |part|
          parse_part(part)
        end
      when :lvasgn
        # single assign method
        parse_lvasgn(block)
      end
    end

    def parse_send(block)
      to_object, method, *args = block.to_a
      method
    end

    def parse_part(part)
      case part.type
      when :def
        parse_method(part)
      when :ivasgn
        parse_ivasgn(part)
      when :lvasgn
        parse_lvasgn(part)
      end
    end

    def parse_method(method)
      name, args, body = method.to_a
      parse_block(body)
    end

    def parse_ivasgn(ivasgn)
      name, value = ivasgn.to_a

      add_var(name, parse_value(value))
    end

    def parse_lvasgn(lvasgn)
      name, value = lvasgn.to_a

      add_var(name, parse_value(value))
    end

    def parse_value(value)
      result = { type: value.type }

      result[:value] = case value.type
      when :lvar
        parse_lvar(value)
      when :send
        parse_send(value)
      when :str, :sym
        value.to_a.first
      end

      result
    end

    def parse_lvar(value)
      name, *_ = value.to_a
      name
    end
  end
end
