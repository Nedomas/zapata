module Zapata
  RETURN_TYPES = %i(sym float str int lvar true false)
  DIVE_TYPES = %i(begin block defined? nth_ref splat kwsplat class
    block_pass sclass masgn or and irange erange when and
    return array kwbegin yield while dstr ensure pair)
  ASSIGN_TYPES = %i(ivasgn lvasgn or_asgn casgn)
  DEF_TYPES = %i(def defs)
  HARD_TYPES = %i(dsym resbody mlhs const nil next self false true break zsuper
    super retry rescue match_with_lvasgn case op_asgn regopt regexp)
  TYPES_BY_SEARCH_FOR = { var: ASSIGN_TYPES, def: DEF_TYPES, send: %i(send) }

  class CodeDiver
    def initialize(search_for)
      @search_for = search_for
    end

    def dive_types
      TYPES_BY_SEARCH_FOR[@search_for]
    end

    def dive(code)
      type = code.type

      result = if RETURN_TYPES.include?(type)
        Primitive.new(code, self)
      elsif ASSIGN_TYPES.include?(type)
        VarAssignment.new(code, self)
      elsif DEF_TYPES.include?(type)
        DefAssignment.new(code, self)
      elsif type == :send
        Send.new(code, self)
      elsif type == :args
        PrimitiveArray.new(code, self)
      elsif type == :hash
        PrimitiveHash.new(code, self)
      elsif type == :ivar
        PrimitiveIvar.new(code, self)
      elsif type == :arg or type == :optarg
        PrimitiveArg.new(code, self)
      elsif HARD_TYPES.include?(type)
      else
      end

      AssignmentRecord.create(result) if dive_types.include?(type)
      deeper_dives(code.to_a) if DIVE_TYPES.include?(type)
      result
    end

    def deeper_dives(parts)
      parts.each do |part|
        if part
          dive(part)
        else
          { type: :error, code: part }
        end
      end
    end
  end
end
