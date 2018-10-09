lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logging/plugins/journald'

Gem::Specification.new do |spec|
  spec.name          = 'logging-journald'
  spec.version       = Logging::Plugins::Journald::VERSION
  spec.authors       = ['Lukas Zapletal']
  spec.email         = ['lukas-x@zapletalovi.com']
  spec.summary       = "Journald appender for logging gem"
  spec.description   = "Plugin for logging gem providing journald appender"
  spec.homepage      = 'https://github.com/lzap/logging-journald'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency 'journald-logger'
  spec.add_runtime_dependency 'logging'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'test-unit'
end
