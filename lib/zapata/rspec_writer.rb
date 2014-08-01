module Zapata
  class Writer
    def initialize(filename)
      @file = File.open("#{filename}.rb", 'w')
      @padding = 0
      clean
    end

    def clean
      @file.write('')
    end

    def append_line(line='')
      if line.match('end')
        @padding -= 1
      end

      @file.puts("#{'  ' * @padding}#{line}")

      if line.match('do')
        @padding += 1
      end
    end
  end

  class RspecWriter
    attr_reader :result

    def initialize(code, var_analysis)
      @var_analysis = var_analysis
      @template_spec = CodeParser.new('test_files/template_spec').code
      @writer = Writer.new('test_files/zapata_spec')
      @result = {}

      case code.type
      when :class
        parse_klass(code)
      end
    end

    def add_var(name, value)
      @result[name] ||= []
      @result[name] << value
    end

    def parse_klass(class_code)
      @klass, inherited_from_klass, body = class_code.to_a

      @writer.append_line("require 'spec_helper'")
      @writer.append_line

      @writer.append_line("describe #{klass_name}Spec do")
      @writer.append_line

      @writer.append_line("let(:#{klass_name.downcase}) { #{klass_name}.new() }")
      @writer.append_line

      parse_body(body)
      @writer.append_line('end')
    end

    def klass_name
      module_name, klass_name = @klass.to_a
      klass_name
    end

    def parse_body(body)
      case body.type
      when :begin
        parse_block(body)
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
      end
    end

    def parse_method(method)
      name, args, body = method.to_a
      calculated_args = heuristic_args(args)
      text_args = !calculated_args.empty? ? "(#{calculated_args.join(', ')})" : ''

      @writer.append_line("describe '##{name}' do")
      @writer.append_line(
        "expect(@#{klass_name.downcase}.#{name}#{text_args}).to eq()"
      )

      @writer.append_line('end')
      @writer.append_line
    end

    def heuristic_args(args)
      args.to_a.map do |arg|
        var_name = arg.to_a.first
        # fallback if not found
        value = choose_arg_value(var_name)
        arg_for_print(value)
      end
    end

    def arg_for_print(value)
      case value
      when String
        "'#{value}'"
      when Symbol
        ":#{value}"
      end
    end

    def choose_arg_value(var_name)
      value = @var_analysis[var_name].andand.first
      return "NEVER_SET_#{var_name}" unless value

      case value[:type]
      when :lvar
        "UNSURE_LVAR_#{value[:value]}"
      when :send
        "UNSURE_METHOD_#{value[:value]}"
      when :str, :sym
        value[:value]
      end
    end

    def parse_ivasgn(ivasgn)
      name, value = ivasgn.to_a

      add_var(name, parse_value(value))
    end

    def parse_value(value)
      case value.type
      when :lvar
        parse_lvar(value)
      when :send
        parse_send(value)
      end
    end

    def parse_lvar(value)
      name, *_ = value.to_a
      name
    end
  end
end
