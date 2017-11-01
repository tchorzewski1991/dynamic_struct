module DynamicStruct
  class Corpus
    def initialize(arguments)
      @atoms = {} and verify(arguments)
    end

    def inspect
      klass = self.class

      if atoms?
        %Q(<%s %s>) % [
          klass,
          atoms.map { |k, v| "%s=%s" % [k, v.inspect] } * ' '
        ]
      else
        %Q(<%s>) % klass
      end
    end

    def atoms?
      atoms.any?
    end

    private
    attr_reader :atoms

    def verify(arguments)
      Hash === arguments && arguments.any?
    end
  end
end
