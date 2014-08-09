module Zapata
  module Primitive
    class Klass < Base
      def initialize(code)
        @code = code
        @moduls = Diver.current_moduls.dup
        Diver.access_level = :public
        Diver.current_klass = self
        dive_deeper
        Diver.current_klass = nil
      end

      def parent_modul_names
        @moduls.map { |mod| mod and mod.name }.compact
      end

      def node
        const, inherited_from_klass, body = @code.to_a
        immediate_modul, klass = const.to_a
        chain = parent_modul_names + [immediate_modul, klass]
        name = chain.compact.join('::')
        type = @code.type

        OpenStruct.new(
          type: type,
          immediate_modul: immediate_modul,
          klass: klass,
          name: name,
          body: body
        )
      end
    end
  end
end
