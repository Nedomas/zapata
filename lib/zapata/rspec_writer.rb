module Zapata
  class RSpecWriter
    attr_reader :spec_filename

    def initialize(filename, code, helper_file, var_analysis, spec_analysis = nil)
      @var_analysis = var_analysis
      @spec_analysis = spec_analysis
      @helper_file = helper_file
      @spec_filename = filename.gsub('app', 'spec').gsub('.rb', '_spec.rb')
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

      @writer.append_line("require '#{@helper_file}'")
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
      method = MethodMock.new(name_node, args, body, @var_analysis, @instance)

      if method.name == :initialize
        @instance.args_to_s = method.predicted_args_to_s
        write_let_from_initialize
      else
        write_method(method)
      end
    end

    def write_let_from_initialize
      @writer.append_line(
        "let(:#{@instance.name_underscore}) { #{@instance.initialize_to_s} }"
      )
      @writer.append_line
    end

    def write_method(method)
      return if method.empty?

      @writer.append_line("it '##{method.name}' do")

      @writer.append_line(
        "expect(#{@instance.name_underscore}.#{method.name}#{method.predicted_args_to_s}).to eq(#{write_equal(method.name)})"
      )

      @writer.append_line('end')
      @writer.append_line
    end

    def write_equal(method_name)
      if @spec_analysis
        Printer.value(@spec_analysis.expected(method_name))
      else
        Printer.value('FILL IN THIS BY HAND')
      end
    end
  end
end
