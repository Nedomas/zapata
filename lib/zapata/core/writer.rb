module Zapata
  module Core
    class Writer
      def initialize(filename)
        @filename = filename
        @padding = 0
        clean
      end

      def clean
        file = File.open(@filename, 'w')
        file.write('')
        file.close
      end

      def append_line(line = '')
        @padding -= 1 if word_exists?(line, 'end')

        padding_to_use = @padding
        padding_to_use = 0 if line.empty?
        file = File.open(@filename, 'ab+')
        file.puts("#{'  ' * padding_to_use}#{line}")
        file.close

        @padding += 1 if word_exists?(line, 'do')
      end

      def word_exists?(string, word)
        !!/\b(?:#{word})\b/.match(string)
      end
    end
  end
end
