module Zapata
  RETURN_TYPES = %i(hash sym float str int lvar ivar true false)
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

    def map_dives(parts)
      parts.map do |part|
        if part
          dive(part)
        else
          { type: :error, code: part }
        end
      end
    end

    def dive(code)
      type = code.type

      if RETURN_TYPES.include?(type)
        Primitive.new(code, self)
        # value(type, parts.last)
      elsif DIVE_TYPES.include?(type)
        map_dives(code.to_a)
      elsif ASSIGN_TYPES.include?(type)
        new_assignment = VarAssignment.new(code, self)

        AssignmentRecord.create(new_assignment) if dive_types.include?(type)
        new_assignment
      elsif DEF_TYPES.include?(type)
        new_assignment = DefAssignment.new(code, self)

        AssignmentRecord.create(new_assignment) if dive_types.include?(type)
        new_assignment
      elsif HARD_TYPES.include?(type)
      elsif type == :send
        new_send = Send.new(code, self)

        if dive_types.include?(type)
          AssignmentRecord.create(new_send)
        end
        new_send
      elsif type == :args
        PrimitiveArray.new(code, self)
      elsif type == :arg or type == :optarg
        Arg.new(code, self)
      elsif type == :if
      else
      end
    end
  end
end
