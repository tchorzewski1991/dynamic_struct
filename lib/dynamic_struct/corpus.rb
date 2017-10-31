module DynamicStruct
  class Corpus
    def initialize(arguments)
      @atoms = {}
    end

    def atoms?
      atoms.any?
    end

    private
    attr_reader :atoms
  end
end
