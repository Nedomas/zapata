module Zapata
  module RZpec
    class Writer
      attr_reader :spec_filename

      def initialize(filename, code, subject_analysis, whole_analysis, spec_analysis = nil)
        @subject_analysis = subject_analysis
        @whole_analysis = whole_analysis
        @spec_analysis = spec_analysis
        @spec_filename = filename.gsub('app', 'spec').gsub('.rb', '_spec.rb')
        @writer = Writer.new(spec_filename)
        @result = {}

        klasses.each do |klass|
          write_class(klass)
        end
      end

      def klasses
        @subject_analysis.select { |obj| obj.is_a?(Klass) }
      end

      def subject_methods
        @subject_analysis.select { |assignment| assignment.is_a?(Def) }
      end

      def write_class(klass)
        @writer.append_line("require '#{File::Loader.helper_path}'")
        @writer.append_line

        @writer.append_line("describe #{klass.name} do")
        @writer.append_line

        subject_methods.each do |method|
          write_for_method(method)
        end

        @writer.append_line('end')
      end

      def write_for_method(primitive_def)
        method = MethodMock.new(def_assignment.name, def_assignment.args,
          def_assignment.body, @var_analysis, @instance)

        method.arg_ivars.each do |ivar|
          write_let_from_ivar(ivar)
        end

        if method.name == :initialize
          @instance.args_to_s = method.predicted_args_to_s
          write_let_from_initialize
        else
          write_method(method)
        end
      end

      def write_let_from_ivar(ivar)
        @writer.append_line(
          "let(:#{SaveManager.clean(underscore(ivar))}) { Zapata::Missing.new }"
        )
      end

      def write_let_from_initialize
        @writer.append_line(
          "let(:#{underscore(@instance.name)}) { #{@instance.initialize_to_s} }"
        )
        @writer.append_line
      end

      def write_method(method)
        return if method.empty?

        @writer.append_line("it '##{method.name}' do")

        @writer.append_line(
          "expect(#{underscore(@instance.name)}.#{method.name}#{method.predicted_args_to_s}).to eq(#{write_equal(method.name)})"
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

      def underscore(name)
        name.to_s.underscore
      end
    end
  end
end
