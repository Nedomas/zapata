module Zapata
  class Writer
    def initialize(filename)
      @file = File.open(filename, 'w')
      @padding = 0
      clean
    end

    def clean
      @file.write('')
    end

    def append_line(line = '')
      @padding -= 1 if word_exists?(line, 'end')

      padding_to_use = @padding
      padding_to_use = 0 if line.empty?
      @file.puts("#{'  ' * padding_to_use}#{line}")

      @padding += 1 if word_exists?(line, 'do')
    end

    def word_exists?(string, word)
      !!/\b(?:#{word})\b/.match(string)
    end

    class << self
      def arg_for_print(value)
        case value
        when String
          "'#{value}'"
        when Symbol
          ":#{value}"
        when Evaluation
          value
        else
          value
        end
      end
    end
  end
end
