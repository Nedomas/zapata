module Zapata
  module RSpec
    class Writer
      attr_reader :spec_filename

      def initialize(filename, code, subject_analysis, helper_file, var_analysis, spec_analysis = nil)
        @subject_analysis = subject_analysis
        @var_analysis = var_analysis
        @spec_analysis = spec_analysis
        @helper_file = helper_file
        @spec_filename = filename.gsub('app', 'spec').gsub('.rb', '_spec.rb')
        @writer = Writer.new(spec_filename)
        @result = {}

        write_class(klass)
      end

      def klass
        @subject_analysis.select { |obj| obj.class == Klass }
      end

      def subject_methods
        @subject_analysis.select { |assignment| assignment.class == DefAssignment }
      end

      def write_class(klass)
        @writer.append_line("require '#{@helper_file}'")
        @writer.append_line

        @writer.append_line("describe #{@instance.name} do")
        @writer.append_line

        subject_methods.each do |method|
          write_for_method(method)
        end

        @writer.append_line('end')
      end

      def parse_klass(class_code)
        name, inherited_from_klass, body = class_code.to_a
        @instance = InstanceMock.new(name, inherited_from_klass, body)

      end

      def write_for_method(def_assignment)
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
