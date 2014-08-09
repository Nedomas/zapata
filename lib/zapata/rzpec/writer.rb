module Zapata
  module RZpec
    class Writer
      attr_accessor :spec_filename

      class << self
        attr_accessor :ivars

        def reset_ivars
          @ivars = []
        end
      end

      def initialize(filename, code, subject_analysis, whole_analysis, spec_analysis = nil)
        self.class.reset_ivars
        @subject_analysis = subject_analysis
        @whole_analysis = whole_analysis
        @spec_analysis = spec_analysis
        @spec_filename = filename.gsub('app/', 'spec/').gsub('.rb', '_spec.rb')
        @writer = Core::Writer.new(spec_filename)
        @result = {}

        klasses.each do |klass|
          write_class(klass)
        end

        self.class.reset_ivars
      end

      def klasses
        @subject_analysis.select { |obj| obj.is_a?(Primitive::Klass) }
      end

      def subject_defs
        @subject_analysis.select do |method|
          [Primitive::Def, Primitive::Defs].include?(method.class) and
            method.public?
        end
      end

      def initialize_def
        subject_defs.detect { |method| method.name == :initialize }
      end

      def write_class(klass)
        @writer.append_line("require '#{Core::Loader.helper_name}'")
        @writer.append_line

        @writer.append_line("describe #{klass.name} do")

        write_instance_let(klass)

        subject_defs.each do |primitive_def|
          write_method(primitive_def)
        end

        self.class.ivars.each do |ivar|
          predicted_value = Predictor::Args.choose_value(ivar.value)
          literal_predicted_value = Printer.print(predicted_value.to_raw)
          write_let(ivar.value, literal_predicted_value)
        end

        @writer.append_line('end')
      end

      def write_instance_let(klass)
        if initialize_def
          write_let_from_initialize
        else
          write_let(klass.name, "#{klass.name}.new")
        end
      end

      def write_let(name, block)
        @writer.append_line("let(:#{Printer.to_var_name(name)}) do")
        @writer.append_line(block)
        @writer.append_line('end')
      end

      def write_let_from_initialize
        block = "#{initialize_def.klass.name}.new#{initialize_def.literal_predicted_args}"
        write_let(initialize_def.klass.name, block)
      end

      def write_method(primitive_def)
        return unless primitive_def.node.body
        return if primitive_def.name == :initialize

        @writer.append_line
        @writer.append_line("it '##{primitive_def.name}' do")

        receiver = if primitive_def.self?
          primitive_def.klass.name
        else
          Printer.to_var_name(primitive_def.klass.name)
        end

        @writer.append_line(
          "expect(#{receiver}.#{primitive_def.name}#{primitive_def.literal_predicted_args}).to eq(#{write_equal(primitive_def.name)})"
        )

        @writer.append_line('end')
      end

      def write_equal(method_name)
        if @spec_analysis
          Printer.print(Primitive::Raw.new(:literal, @spec_analysis.expected(method_name)))
        else
          Printer.print(Primitive::Raw.new(:str, 'FILL IN THIS BY HAND'))
        end
      end

    end
  end
end
