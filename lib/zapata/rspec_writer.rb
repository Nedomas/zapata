module Zapata
  class RspecWriter
    attr_reader :result

    def initialize(filename, code, var_analysis)
      @var_analysis = var_analysis
      # @template_spec = CodeParser.parse('test_files/template_spec').code
      spec_filename = filename.gsub('app', 'spec').gsub('.rb', '_spec.rb')
      @writer = Writer.new(spec_filename)
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

      @writer.append_line("require 'rails_helper'")
      @writer.append_line

      @writer.append_line("describe #{klass_name} do")
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

      if name == :initialize
        write_let_from_initialize(name, args, body)
      else
        write_method(name, args, body)
      end
    end

    def write_let_from_initialize(name, args, body)
      @writer.append_line(
        "let(:#{klass_name_underscore}) { #{klass_name}.new#{predicted_args(args)} }"
      )
      @writer.append_line
    end

    def klass_name_underscore
      klass_name.to_s.underscore
    end

    def write_method(name, args, body)
      @writer.append_line("describe '##{name}' do")

      @writer.append_line("it 'should work as planned' do")

      @writer.append_line(
        "expect(#{klass_name_underscore}.#{name}#{predicted_args(args)}).to eq('somethin')"
      )

      @writer.append_line('end')
      @writer.append_line('end')
      @writer.append_line
    end

    def predicted_args(args)
      calculated_args = heuristic_args(args)
      !calculated_args.empty? ? "(#{calculated_args.join(', ')})" : ''
    end

    def heuristic_args(args)
      args.to_a.map do |arg|
        var_name = arg.to_a.first
        # fallback if not found
        value = choose_arg_value(var_name)
        Writer.arg_for_print(value)
      end
    end

    def choose_arg_value(var_name)
      possible_values = @var_analysis[var_name] || []
      return MissingVariable.new(:never_set, var_name) if possible_values.empty?

      value = choose_by_probability(possible_values)

      case value[:type]
      when :lvar, :send
        MissingVariable.new(value[:type], value[:value])
      when :str, :sym
        value[:value]
      end
    end

    PRIMITIVE_TYPES = %i(str sym)

    def choose_by_probability(possible_values)
      most_probable_by_count = most_probable_by_counts(possible_values)

      result = if PRIMITIVE_TYPES.include?(most_probable_by_count[:type])
        most_probable_by_count
      else
        possible_values.delete(most_probable_by_count)
        choose_by_probability(possible_values)
      end

      result || most_probable_by_count
    end

    def most_probable_by_counts(possible_values)
      group_with_counts(possible_values).max_by { |k, v| v }.first
    end

    def group_with_counts(values)
      values.each_with_object(Hash.new(0)) do |value, obj|
        obj[value] += 1
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
