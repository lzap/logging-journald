Gem::Specification.new do |spec|
  spec.name          = 'logging-journald'
  spec.version       = '2.0.3'
  spec.authors       = ['Lukas Zapletal']
  spec.email         = ['lukas-x@zapletalovi.com']
  spec.summary       = "Journald appender for logging gem"
  spec.description   = "Plugin for logging gem providing journald appender"
  spec.homepage      = 'https://github.com/lzap/logging-journald'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'journald-logger', '~> 2.0'
  spec.add_runtime_dependency 'logging'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'test-unit'
end
