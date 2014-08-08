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

      def subject_methods
        @subject_analysis.select { |assignment| assignment.is_a?(Primitive::Def) }
      end

      def write_class(klass)
        @writer.append_line("require '#{Core::Loader.helper_path}'")
        @writer.append_line

        @writer.append_line("describe #{klass.name} do")
        @writer.append_line

        write_let_from_initialize(klass)

        subject_methods.each do |method|
          write_method(klass, method)
        end

        @writer.append_line('end')
      end

      def write_let_from_initialize(klass)
        initialize_def = subject_methods.find { |meth| meth.name == :initialize }

        @writer.append_line("let(:#{underscore(klass.name)}) do")

        @writer.append_line("#{klass.name}.new#{initialize_def.literal_predicted_args}")
        @writer.append_line('end')

        @writer.append_line
      end

      def write_method(klass, method)
        return unless method.node.body
        return if method.name == :initialize

        @writer.append_line("it '##{method.name}' do")

        @writer.append_line(
          "expect(#{underscore(klass.name)}.#{method.name}#{method.literal_predicted_args}).to eq(#{write_equal(method.name)})"
        )

        @writer.append_line('end')
        @writer.append_line
      end


#
#       def write_for_method(klass, primitive_def)
# #         method.arg_ivars.each do |ivar|
# #           write_let_from_ivar(ivar)
# #         end
# #
#         if primitive_def.name == :initialize
#           write_let_from_initialize(primitive_def)
#         else
#           write_method(primitive_def)
#         end
#       end

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
