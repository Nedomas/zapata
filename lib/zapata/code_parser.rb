module Zapata
  class CodeParser
    def initialize(filename)
      @plain_text_code = File.open("#{filename}.rb").read
    end

    def code
      Parser::CurrentRuby.parse(@plain_text_code)
    end
  end
end
