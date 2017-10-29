# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dynamic_struct/version'

Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY

  spec.name        = 'dynamic_struct'
  spec.version     = DynamicStruct::VERSION
  spec.summary     = 'DynamicStruct'
  spec.description = 'DynamicStruct is a data structure similar to OpenStruct, but a little more optimized.'
  spec.author      = 'Rafał Tchórzewski'
  spec.email       = 'tchorzewski.rafal@gmail.com'
  spec.homepage    = 'https://github.com/tchorzewski1991/dynamic_struct'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 2.4.0'

  spec.files         = Dir["{lib}/**/*", 'LICENSE', 'README.md']
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'benchmark-ips', '~> 2.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop', '~> 0.46.0'
end
