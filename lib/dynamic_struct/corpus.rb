module DynamicStruct
  class Corpus
    def initialize(arguments)
      @atoms = {}
    end

    private
    attr_reader :atoms
  end
end
