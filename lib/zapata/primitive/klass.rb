module Zapata
  module Primitive
    class Klass < Base
      def initialize(code)
        @code = code
        @modul = Diver.current_modul
        Diver.access_level = :public
        Diver.current_klass = self
        dive_deeper
        Diver.current_klass = nil
      end

      def parent_modul_name
        @modul and @modul.name
      end

      def node
        const, inherited_from_klass, body = @code.to_a
        immediate_modul, klass = const.to_a
        name = [parent_modul_name, immediate_modul, klass].compact.join('::')
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
