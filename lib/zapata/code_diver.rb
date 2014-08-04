module Zapata
  class CodeDiver
    attr_reader :result

    def initialize(class_code)
      @klass, @inherited_from_klass, @body = class_code.to_a
      @result = {}
    end

    def scan_variables
      dive(@body.type, @body)
    end

    RETURN_TYPES = %i(sym float str int lvar ivar)
    DIVE_TYPES = %i(begin block regexp regopt defined? nth_ref splat kwsplat
      block_pass sclass masgn mlhs or irange erange rescue resbody when and
      return case array kwbegin yield while op_asgn dstr ensure pair)
    ASSIGN_TYPES = %i(ivasgn lvasgn or_asgn casgn)
    DEF_TYPES = %i(def defs)
    HARD_TYPES = %i(const nil next self false true break zsuper super retry)

    def map_dives(parts)
      parts.map do |part|
        dive(part.type, part)
      end
    end

    def dive(type, code)
      parts = code.to_a

      if RETURN_TYPES.include?(type)
        value(type, parts.last)
      elsif DIVE_TYPES.include?(type)
        map_dives(parts)
      elsif (ASSIGN_TYPES + DEF_TYPES).include?(type)
        dive_and_document(type, parts)
      elsif type == :send
        to_object, method, *args = code.to_a

        args.each do |arg|
          dive(arg.type, arg)
        end

        value(type, method)
      elsif type == :true
        value(type, true)
      elsif type == :false
        value(type, false)
      elsif type == :hash
        keys_and_values = parts.map do |part|
          map_dives(part.to_a)
        end

        value(type, keys_and_values)
      elsif type == :args
#       *unnested_args = args.to_a
#
#       return unnested_args.map do |arg|
#         name, _ = arg.to_a
#         name
#       end
      elsif type == :if
#       condition, on_true, on_false = question.to_a
#
#       dig(question)
      end
    end

    def dive_and_document(type, code)
      parts = code.to_a

      method_name = parts.first
      method_body = parts.last
      return unless method_body

      document(method_name, value(type, dive(method_body.type, method_body)))
    end

    def document(name, value)
      clean_name = clean(name)

      @result[clean_name] ||= []
      @result[clean_name] << value
    end

    def clean(name)
      name.to_s.delete('@').to_sym
    end

    def value(type, code)
      if code.is_a?(Hash)
        code
      else
        { type: type, code: code }
      end
    end
  end
end