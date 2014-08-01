require 'parser/current'
require 'pry'
require 'pry-stack_explorer'
require 'andand'
require_relative 'zapata/analyst'
require_relative 'zapata/version'

module Zapata
  class Revolutionist
    def initialize(all_files)
      @analysis_of_all_files = Analyst.analize(all_files)
    end

    def generate_rspec_for(filename)
      Analyst.new(filename, @analysis_of_all_files).rspec
    end
  end
end

# file_list = %w(test test2 actual_fragment notes_controller)
file_list = %w()
p Zapata::Revolutionist.new(file_list).generate_rspec_for('test_files/class_to_test')

#     def aggregate_variables
#       case @parsed_code.type
#       when :class
#         parse_class(@parsed_code)
#       when :module
#         classes = @parsed_code.children.select { |node| node.type == :class }
#
#         classes.each do |klass|
#           parse_class(klass)
#         end
#       end
#     end
#
#     def parse_class(klass_code)
#       name, args, body = klass_code.to_a
#
#       methods = body.children.select do |child|
#         child.respond_to?(:type) and child.type == :def
#       end
#
#       if body.respond_to?(:type) and body.type == :def
#         methods << body
#       end
#
#       methods.each do |method|
#         name, args, body = method.to_a
#
#         var_assignments = body.to_a.select do |line|
#           line.respond_to?(:type) and %i(lvasgn ivasgn).include?(line.type)
#         end
#
#         var_assignments.each do |assignment|
#           var_name, value = assignment.to_a
#
#           @var_types[var_name] ||= []
#
#           if value.type == :send
#             @var_types[var_name] << parse_send(value)
#           else
#             @var_types[var_name] << value.type.to_s
#           end
#         end
#       end
#     end
#
#     def parse_send(node)
#       obj_name, obj_method, *obj_args = node.to_a
#
#       if obj_name.type == :send
#         parse_send(obj_name)
#       else
#         pretty_name = pretty_obj_name(obj_name)
#         pretty_args = pretty_args(obj_args)
#         result = "#{pretty_name}.#{obj_method}(#{pretty_args})"
#       end
#     end
#
#     def pretty_obj_name(obj_name)
#       obj_symbols = obj_name.to_a.map do |o|
#         o.respond_to?(:to_a) ? o.to_a : o
#       end.flatten.compact
#
#       obj_symbols.join('::')
#     end
#
#     def pretty_args(args)
#       arg_symbols= args.map { |o| o.to_a.last }
#
#       arg_symbols.join(', ')
#     end
#   end
#
# end
#
# def self.run
#   result = []
#   # file_list = %w(test test2 actual_fragment notes_controller)
#   file_list = %w(test)
#   file_list.each do |file|
#     result << Zapata::Revolutionist.new("test_files/#{file}.rb").var_types
#   end
#
#   final = {}
#   result.each do |r|
#     r.each do |k, v|
#       final[k] ||= []
#       final[k] << v
#       final[k].flatten!
#     end
#   end
#   pp final
# end
#
# run
