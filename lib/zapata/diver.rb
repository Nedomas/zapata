module Zapata
  RETURN_TYPES = %i(missing raw const_send sym float str int ivar true false const nil)
  DIVE_TYPES = %i(args begin block defined? nth_ref splat kwsplat class
    block_pass sclass masgn or and irange erange when and
    return array kwbegin yield while dstr ensure pair)
  ASSIGN_TYPES = %i(ivasgn lvasgn or_asgn casgn optarg)
  DEF_TYPES = %i(def defs)
  HARD_TYPES = %i(if dsym resbody mlhs next self break zsuper
    super retry rescue match_with_lvasgn case op_asgn regopt regexp)
  TYPES_BY_SEARCH_FOR = {
    klass: %i(class),
    var: ASSIGN_TYPES,
    def: DEF_TYPES,
    send: %i(send),
  }

  PRIMITIVE_TYPES = {
    Def: %i(def),
    Defs: %i(defs),
    Send: %i(send),
    Array: %i(args array),
    Hash: %i(hash),
    Ivar: %i(ivar),
    Lvar: %i(lvar),
    Klass: %i(class),
    Sklass: %i(sclass),
    Modul: %i(module),
    Const: %i(const),
    Optarg: %i(optarg),
    Arg: %i(arg),
    Basic: RETURN_TYPES,
    Casgn: %i(casgn),
    Var: ASSIGN_TYPES,
  }.freeze

  class Diver
    class << self
      attr_accessor :current_moduls, :current_klass, :current_sklass, :access_level

      def search_for(what)
        @search_for = what
        @current_moduls ||= []
      end

      def dive(code)
        unless code
          return Primitive::Nil.new
        end

        current_type = code.type
        return Primitive::Raw.new(:missing, :hard_type) if HARD_TYPES.include?(current_type)

        subklass_pair = PRIMITIVE_TYPES.detect do |_, types|
          types.include?(current_type)
        end

        if subklass_pair
          klass = "Zapata::Primitive::#{subklass_pair.first}".constantize
          result = klass.new(code)

          DB.create(result) if search_for_types.include?(current_type)
        else
        end

        deeper_dives(code) if DIVE_TYPES.include?(current_type)

        result || Primitive::Raw.new(:super, nil)
      end

      def search_for_types
        TYPES_BY_SEARCH_FOR[@search_for]
      end

      def deeper_dives(code)
        code.to_a.compact.each do |part|
          dive(part)
        end
      end
    end
  end
end
