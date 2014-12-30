# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/aws/version'

Gem::Specification.new do |spec|
  spec.name          = "fog-aws"
  spec.version       = Fog::Aws::VERSION
  spec.authors       = ["Josh Lane"]
  spec.email         = ["me@joshualane.com"]
  spec.summary       = %q{Module for the 'fog' gem to support Amazon Web Services.}
  spec.description   = %q{This library can be used as a module for `fog` or as standalone provider
                        to use the Amazon Web Services in applications..}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "fog-core"
  spec.add_dependency "fog-xml"
end
