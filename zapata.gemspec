# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zapata/version'

Gem::Specification.new do |spec|
  spec.name          = 'zapata'
  spec.version       = Zapata::VERSION
  spec.authors       = ['Domas Bitvinskas']
  spec.email         = ['domas.bitvinskas@me.com']
  spec.summary       = %q(Automatic automated test writer)
  spec.description   = %q(Who has time to write tests? This is a revolutional tool to make them write themselves.)
  spec.homepage      = 'https://github.com/Nedomas/zapata'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['zapata']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'parser'
  spec.add_runtime_dependency 'andand'
  spec.add_runtime_dependency 'pry'
  spec.add_runtime_dependency 'pry-stack_explorer'
  spec.add_runtime_dependency 'rails'
  spec.add_runtime_dependency 'slop'
  spec.add_runtime_dependency 'rspec-rails'
  spec.add_runtime_dependency 'require_all'
  # spec.add_runtime_dependency 'redis'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
end
