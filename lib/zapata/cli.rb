# frozen_string_literal: true

require 'thor'
require_relative 'version'

module Zapata
  class CLI < Thor
    desc 'generate FILENAME', 'Generate spec file for model'
    option :single, type: :boolean,
                    desc: 'Skip app/models analysis',
                    aliases: :s
    def generate(filename)
      Zapata::Revolutionist.generate_with_friendly_output(
        filename: filename, single: options[:single]
      )
    end

    desc 'version', 'Shows zapata version'
    def version
      puts "v#{Zapata::VERSION}"
    end
  end
end
