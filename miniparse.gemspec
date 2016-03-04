# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miniparse/version'

Gem::Specification.new do |spec|
  spec.name          = "miniparse"
  spec.version       = Miniparse::VERSION
  spec.authors       = ["Juanma Rodriguez"]
  spec.email         = ["jmrod4@gmail.com"]

  spec.summary       = %q{Miniparse is a easy of use yet flexible and powerful ruby library for parsing command-line options.}
#  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/jmrod4/miniparse"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  #spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
