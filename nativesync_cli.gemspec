# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nativesync_cli/version'

Gem::Specification.new do |gem|
  gem.name          = "nativesync_cli"
  gem.version       = NativeSyncCli::VERSION
  gem.authors       = ["Nick Bryant"]
  gem.email         = ["nick@nativesync.io"]
  gem.description   = %q{NativeSync Command Line Tool}
  gem.summary       = %q{This tool allows developers to build apps on nativesync using the command line.}
  gem.homepage      = "https://github.com/nativesync/nativesync-cli"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "thor", "~> 0.19.1"
  gem.add_runtime_dependency "json", "~> 1.8.3"
  gem.add_runtime_dependency "rest-client", "~> 1.8.0"
end
