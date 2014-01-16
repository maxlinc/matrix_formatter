# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'matrix_formatter/version'

Gem::Specification.new do |spec|
  spec.name          = "matrix_formatter"
  spec.version       = MatrixFormatter::VERSION
  spec.authors       = ["Max Lincoln"]
  spec.email         = ["max@devopsy.com"]
  spec.description   = "RSpec formatter that produces a feature matrix."
  spec.summary       = "RSpec formatter that produces a feature matrix."
  spec.homepage      = "http://github.com/maxlinc/matrix_formatter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'multi_json'
  spec.add_dependency 'redcarpet'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'hashie'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-fire"
  spec.add_development_dependency "json_spec"
end
