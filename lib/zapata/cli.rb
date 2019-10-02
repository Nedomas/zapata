# frozen_string_literal: true

require 'thor'
require_relative 'version'

module Zapata
  class CLI < Thor

    desc 'generate FILENAME', 'generate spec file for model'
    option :single, type: :boolean, desc: 'skip app/models analysis', aliases: :s
    def generate(filename)
      Zapata::Revolutionist.generate_with_friendly_output(filename: filename, single: options[:single])
    end
  end
end
