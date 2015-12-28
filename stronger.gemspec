$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'stronger/version'

Gem::Specification.new do |s|
  s.name = 'stronger'
  s.version = Stronger::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Jack Forrest']
  s.email = ['jack@jrforrest.net']
  s.homepage = 'https://github.com/jrforrest/stronger'
  s.summary = 'Run-time type checking utils'
  s.description = 'Provides several utilities for run-time type-checking with Ruby'
  s.license = 'WTFPL'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files test`.split("\n")
end
