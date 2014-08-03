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

    def parse_klass(class_code)
      name, inherited_from_klass, body = class_code.to_a
      @instance = InstanceMock.new(name, inherited_from_klass, body)

      @writer.append_line("require 'rails_helper'")
      @writer.append_line

      @writer.append_line("describe #{@instance.name} do")
      @writer.append_line

      parse_body(@instance.body)
      @writer.append_line('end')
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
      end
    end

    def parse_method(method)
      name_node, args, body = method.to_a
      method = MethodMock.new(name_node, args, body, @var_analysis)

      if method.name == :initialize
        @instance.args_to_s = method.predicted_args_to_s
        write_let_from_initialize
      else
        write_method(method)
      end
    end

    def write_let_from_initialize
      @writer.append_line(
        "let(:#{@instance.name}) { #{@instance.initialize_to_s} }"
      )
      @writer.append_line
    end

    def write_method(method)
      @writer.append_line("it '##{method.name}' do")

      @writer.append_line(
        "expect(#{@instance.name_underscore}.#{method.name}#{method.predicted_args_to_s}).to eq('FILL IN THIS BY HAND')"
      )

      @writer.append_line('end')
      @writer.append_line
    end
  end
end
