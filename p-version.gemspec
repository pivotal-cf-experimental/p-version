# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'p_version/version'

Gem::Specification.new do |spec|
  spec.name          = 'p-version'
  spec.version       = PVersion::VERSION
  spec.authors       = ['CF Releng']
  spec.email         = ['cf-release-engineering@pivotallabs.com']
  spec.description   = %q(Write a gem description)
  spec.summary       = %q(Write a gem summary)
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2'

  spec.add_development_dependency 'aruba'
  spec.add_development_dependency 'bundler', '>= 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0.beta2'
  spec.add_development_dependency 'rubocop'
end
