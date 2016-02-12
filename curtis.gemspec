# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'curtis/version'

Gem::Specification.new do |spec|
  spec.name          = "curtis"
  spec.version       = Curtis::VERSION
  spec.authors       = ["Stefan Rotariu"]
  spec.email         = ["stefan.rotariu@gmail.com"]

  spec.summary       = %q{Extremely light wrapper around ncurses-ruby.}
  spec.homepage      = "https://github.com/shuriu/curtis"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'ncurses-ruby', '~> 1.2.4'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", "~> 0.10.3"
  spec.add_development_dependency "binding_of_caller", "~> 0.7.2"
  spec.add_development_dependency "pry-byebug", "~> 3.3.0"
end
