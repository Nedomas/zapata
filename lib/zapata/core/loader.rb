module Zapata
  module Core
    class Loader
      class << self
        def rails_helper_path
          File.expand_path("#{Dir.pwd}/spec/rails_helper",  __FILE__)
        end

        def spec_helper_path
          File.expand_path("#{Dir.pwd}/spec/spec_helper",  __FILE__)
        end

        def helper_name
          if File.exist?("#{rails_helper_path}.rb")
            'rails_helper'
          elsif File.exist?("#{spec_helper_path}.rb")
            'spec_helper'
          else
            raise 'Was not able to load nor rails_helper, nor spec_helper'
          end
        end

        def helper_path
          paths = {
            rails_helper: rails_helper_path,
            spec_helper: spec_helper_path,
          }.freeze

          paths[helper_name.to_sym]
        end

        def load_spec_helper
          require "#{helper_path}.rb"
        end
      end
    end
  end
end
