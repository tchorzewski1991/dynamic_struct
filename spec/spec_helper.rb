require 'simplecov'

SimpleCov.start do
  add_filter %r{^\/spec|^\/benchmarks}

  add_group 'DynamicStruct', '/lib/dynamic_struct.rb'
  add_group 'DynamicStruct::Corpus', '/lib/dynamic_struct/corpus.rb'
end

require "bundler/setup"
require "dynamic_struct"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
