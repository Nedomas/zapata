module Zapata
  class Analyst
    def initialize(filename, analysis_of_all_files)
      @code = CodeParser.new(filename).code
    end

    def rspec
      vars = VarCollector.new(@code).result
      spec = RspecWriter.new(@code, vars).result
    end

    class << self
      def analize(files)
        files.each do |file|
          # parse_file
          # Somehow get data from all files
          # @code = Parser::CurrentRuby.parse(plain_text_code)
          # @analyst = Analyst.new(parsed_code)
        end

        {}
      end
    end
  end

end
