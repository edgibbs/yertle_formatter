# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "yertle_formatter"
  spec.version       = VERSION
  spec.authors       = ["Ed Gibbs"]
  spec.email         = ["edward_gibbs@yahoo.com"]
  spec.summary       = %q{An RSpec 3 formatter highlighting slow specs.}
  spec.description   = %q{Slow specs are marked with turtles and a summary of slow specs are returned at the end of the run.}
  spec.homepage      = "https://github.com/edgibbs/yertle_formatter"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 1.9.3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rspec", ">=3.0.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "guard-rspec"
end
