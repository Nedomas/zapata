# frozen_string_literal: true

module Zapata
  module Core
    class Loader
      class << self
        def spec_dir
          File.join(Dir.pwd, '/spec')
        end

        def rails_helper_path
          File.expand_path("#{spec_dir}/rails_helper", __FILE__)
        end

        def spec_helper_path
          File.expand_path("#{spec_dir}/spec_helper", __FILE__)
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

        def full_helper_path
          paths = {
            rails_helper: rails_helper_path,
            spec_helper: spec_helper_path
          }.freeze

          paths[helper_name.to_sym]
        end

        def load_spec_helper
          $LOAD_PATH << spec_dir
          require helper_name.to_s
        end
      end
    end
  end
end
