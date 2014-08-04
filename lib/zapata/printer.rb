module Zapata
  class Printer
    class << self
      def value(what)
        case what
        when String
          # decide which one to use
          # "\"#{value}\""
          "'#{what}'"
        when Symbol
          ":#{what}"
        when Evaluation
          what
        else
          what
        end
      end
    end
  end
end
