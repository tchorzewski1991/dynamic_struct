# DynamicStruct is data structure similar on OpenStruct,
# but a little more optimized

require_relative './dynamic_struct/version'
require_relative './dynamic_struct/corpus'

module DynamicStruct
  class << self
    def construct(arguments = nil)
      Corpus.new(arguments)
    end
  end
end
