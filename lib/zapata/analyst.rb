module Zapata
  class Analyst
    def initialize(filename, analysis_of_all_files)
      @code = CodeParser.new(filename).code
    end

    def rspec
      @result = {}

      variables = VarCollector.new(@code)
      case @code.type
      when :class
        parse_class(@code)
      end

      @result
    end

    def add_var(name, value)
      @result[name] ||= []
      @result[name] << value
    end

    def parse_class(class_code)
      klass, inherited_from_klass, body = class_code.to_a
      parse_body(body)
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
      parse_block(body)
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

    class << self
      def analize(files)
        files.each do |file|
          # parse_file
          # Somehow get data from all files
          # @code = Parser::CurrentRuby.parse(plain_text_code)
          # @analyst = Analyst.new(parsed_code)
        end

        {}
      end
    end
  end

  class CodeParser
    def initialize(filename)
      @plain_text_code = File.open("#{filename}.rb").read
    end

    def code
      Parser::CurrentRuby.parse(@plain_text_code)
    end
  end

  class VarCollector

  end
end
