# DynamicStruct is data structure similar to OpenStruct,
# but a little more optimized

require_relative './dynamic_struct/version'
require_relative './dynamic_struct/corpus'

module DynamicStruct
  class << self
    def construct(**arguments)
      Corpus.new(arguments).tap do |corpus|
        yield(corpus) if block_given?
      end
    end
  end
end
