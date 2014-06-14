# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "yertle_formatter"
  spec.version       = VERSION
  spec.authors       = ["Ed Gibbs"]
  spec.email         = ["edgibbs@yahoo.com"]
  spec.summary       = %q{An RSpec formatter highlighing slow specs.}
  spec.description   = %q{Another whimsical formatter in the tradition of NyanCatFormatter.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rspec', '~> 3.0.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
