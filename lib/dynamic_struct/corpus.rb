module DynamicStruct
  class Corpus
    def initialize(arguments)
      @atoms = {} and verify(arguments) and assign(arguments)
    end

    def inspect
      klass = self.class

      if atoms?
        %(<%s %s>) % [
          klass,
          atoms.map { |key, value| '%s=%s' % [key, value.inspect] } * ' '
        ]
      else
        %(<%s>) % klass
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

    def assign(arguments)
      arguments.each { |key, value| new_entry(key, value) }
    end
  end
end
