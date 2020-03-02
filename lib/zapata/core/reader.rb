# frozen_string_literal: true

module Zapata
  module Core
    class Reader
      def self.parse(filename)
        plain_text_code = File.open(filename).read
        Parser::CurrentRuby.parse(plain_text_code)
      end
    end
  end
end
