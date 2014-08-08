module Zapata
  module RZpec
    class Writer
      attr_reader :spec_filename

      def initialize(filename, code, subject_analysis, whole_analysis, spec_analysis = nil)
        @subject_analysis = subject_analysis
        @whole_analysis = whole_analysis
        @spec_analysis = spec_analysis
        @spec_filename = filename.gsub('app', 'spec').gsub('.rb', '_spec.rb')
        @writer = Core::Writer.new(spec_filename) rescue binding.pry
        @result = {}

        klasses.each do |klass|
          write_class(klass)
        end
      end

      def klasses
        @subject_analysis.select { |obj| obj.is_a?(Primitive::Klass) }
      end

      def subject_defs
        @subject_analysis.select { |assignment| assignment.is_a?(Primitive::Def) }
      end

      def write_class(klass)
        @writer.append_line("require '#{Core::Loader.helper_path}'")
        @writer.append_line

        @writer.append_line("describe #{klass.name} do")
        @writer.append_line

        write_let_from_initialize

        subject_defs.each do |primitive_def|
          write_method(primitive_def)
        end

        @writer.append_line('end')
      end

      def write_let_from_initialize
        initialize_def = subject_defs.find { |meth| meth.name == :initialize }
        return unless initialize_def

        @writer.append_line("let(:#{underscore(initialize_def.name)}) do")

        @writer.append_line("#{initialize_def.name}.new#{initialize_def.literal_predicted_args}")
        @writer.append_line('end')

        @writer.append_line
      end

      def write_method(primitive_def)
        return unless primitive_def.node.body
        return if primitive_def.name == :initialize

        @writer.append_line("it '##{primitive_def.name}' do")

        receiver = if primitive_def.sklass
          primitive_def.klass.name
        else
          underscore(klass.name)
        end

        @writer.append_line(
          "expect(#{receiver}.#{primitive_def.name}#{primitive_def.literal_predicted_args}).to eq(#{write_equal(primitive_def.name)})"
        )

        @writer.append_line('end')
        @writer.append_line
      end

      # def write_let_from_ivar(ivar)
      #   @writer.append_line(
      #     "let(:#{SaveManager.clean(underscore(ivar))}) { Zapata::Missing.new }"
      #   )
      # end

      def write_equal(method_name)
        if @spec_analysis
          Printer.print(Primitive::Raw.new(:literal, @spec_analysis.expected(method_name)))
        else
          Printer.print(Primitive::Raw.new(:str, 'FILL IN THIS BY HAND'))
        end
      end

      def underscore(name)
        name.to_s.underscore
      end
    end
  end
end
