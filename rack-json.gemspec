# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/json/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-json"
  spec.version       = Rack::Json::VERSION
  spec.authors       = ["Jason Staten"]
  spec.email         = ["jstaten07@gmail.com"]
  spec.description   = %q{Rack middleware for parsing json}
  spec.summary       = %q{Rack middleware for parsing json}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack"
end
