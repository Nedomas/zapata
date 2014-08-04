module Zapata
  class CodeReader
    def self.parse(filename)
      plain_text_code = File.open(filename).read
      Parser::CurrentRuby.parse(plain_text_code)
    end
  end
end
