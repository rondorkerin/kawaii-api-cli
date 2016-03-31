# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kawaiiapi_cli/version'

Gem::Specification.new do |gem|
  gem.name          = "kawaiiapi_cli"
  gem.version       = KawaiiApiCli::VERSION
  gem.authors       = ["Nick Bryant"]
  gem.email         = ["nick@nativesync.io"]
  gem.description   = %q{KawaiiApi Command Line Tool}
  gem.summary       = %q{This tool allows developers to build apps on kawaiiAPI using the command line.}
  gem.homepage      = "https://github.com/sbryant31/kawaiiapi-cli"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "thor", "~> 0.19.1"
  gem.add_runtime_dependency "json", "~> 1.8.3"
  gem.add_runtime_dependency "rest-client", "~> 1.8.0"
  gem.add_runtime_dependency "erubis", "~> 2.7.0"
  gem.add_runtime_dependency "activesupport", "~> 4.2.6"
end
