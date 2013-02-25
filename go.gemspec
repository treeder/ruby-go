
require File.expand_path('../lib/go/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Travis Reeder"]
  gem.email         = ["treeder@gmail.com"]
  gem.description   = "A concurrency library for Ruby inspired by Go (golang)."
  gem.summary       = "A concurrency library for Ruby inspired by Go (golang)."
  gem.homepage      = "https://github.com/treeder/go"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "go"
  gem.require_paths = ["lib"]
  gem.version       = Go::VERSION

  gem.required_rubygems_version = ">= 1.3.6"
  gem.required_ruby_version = Gem::Requirement.new(">= 1.9")

  gem.add_runtime_dependency "concur"

  gem.add_development_dependency "test-unit"

end