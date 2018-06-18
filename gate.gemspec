# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gate/version"

Gem::Specification.new do |spec|
  spec.name = "gate"
  spec.version = Gate::VERSION
  spec.authors = ["Jan Dudulski"]
  spec.email = ["jan@dudulski.pl"]

  spec.summary = "CQRS Command"
  spec.description = "Validate and coerce user input against defined structure."
  spec.homepage = "https://github.com/monterail/gate"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  spec.require_paths = ["lib"]

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.add_runtime_dependency "dry-validation", "~> 0.12"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "rails", "~> 5.2"
  spec.add_development_dependency "rake", "~> 12.0"
end
