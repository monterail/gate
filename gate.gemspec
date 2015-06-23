# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gate/version'

Gem::Specification.new do |spec|
  spec.name          = "gate"
  spec.version       = Gate::VERSION
  spec.authors       = ["Jan Dudulski"]
  spec.email         = ["jan@dudulski.pl"]

  spec.summary       = %q{Handling user input with ease}
  spec.description   = %q{Validate and coerce user input against defined structure.}
  spec.homepage      = "https://github.com/monterail/gate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "coercible", "~> 1.0"
  spec.add_runtime_dependency "axiom-types", "~> 0.1"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10"
end
