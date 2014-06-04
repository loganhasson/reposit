# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reposit/version'

Gem::Specification.new do |spec|
  spec.name          = "reposit"
  spec.version       = Reposit::VERSION
  spec.authors       = ["Logan Hasson"]
  spec.email         = ["logan.hasson@gmail.com"]
  spec.summary       = %q{Create GitHub repos from the command line.}
  spec.description   = %q{Quickly and easily create GitHub repos from the command line.}
  spec.homepage      = "http://github.com/loganhasson/reposit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "bin"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "faraday", "~> 0.9"
  spec.add_runtime_dependency "awesome_print", "~> 1.2"
end
