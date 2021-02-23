# frozen_string_literal: true

require_relative "lib/luminati/version"

Gem::Specification.new do |spec|
  spec.name          = "luminati-ruby"
  spec.version       = Luminati::VERSION
  spec.authors       = ["doublemarket"]
  spec.email         = ["doublemarket@gmail.com"]

  spec.description   = "A Ruby interface to the Luminati API"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/doublemarket/luminati-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/doublemarket/luminati-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/doublemarket/luminati-ruby"

  spec.files = %w[LICENSE.txt README.md luminati-ruby.gemspec] + Dir['lib/**/*.rb']
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 1.0"
end
