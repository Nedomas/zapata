# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zapata/version'

Gem::Specification.new do |spec|
  spec.name          = 'zapata'
  spec.version       = Zapata::VERSION
  spec.authors       = ['Domas Bitvinskas']
  spec.email         = ['domas.bitvinskas@me.com']
  spec.summary       = 'Automatic automated test writer'
  spec.description   = 'Who has time to write tests? This is a revolutional ' \
                       'tool to make them write themselves.'
  spec.homepage      = 'https://github.com/Nedomas/zapata'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['zapata']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'memoist'
  spec.add_runtime_dependency 'parser'
  spec.add_runtime_dependency 'rails'
  spec.add_runtime_dependency 'rspec'
  spec.add_runtime_dependency 'rspec-rails'
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'unparser'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-stack_explorer'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop', '~> 0.80'
  spec.add_development_dependency 'sqlite3'
end
