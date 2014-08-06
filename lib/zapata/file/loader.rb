module Zapata
  module File
    class Loader
      class << self
        def helper_path
          rails_dir = Dir.pwd
          rails_helper_path = File.expand_path("#{rails_dir}/spec/rails_helper",  __FILE__)
          spec_helper_path = File.expand_path("#{rails_dir}/spec/spec_helper",  __FILE__)

          if File.exist?("#{rails_helper_path}.rb")
            'rails_helper'
          elsif File.exist?("#{spec_helper_path}.rb")
            'spec_helper'
          else
            raise 'Was not able to load nor rails_helper, nor spec_helper'
          end
        end

        def load_spec_helper
          require helper_path
        end
      end
    end
  end
end
