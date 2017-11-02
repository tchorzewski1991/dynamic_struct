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

    def new_entry(key, value)
      atoms[key.to_sym] = value
    end

    def method_missing(name, value = nil)
      name = name.to_sym

      atoms.key?(name) ?
        atoms[name] : name.match?(/(\w+)={1}$/) ?
          new_entry(name[0...-1], value) : nil
    end

    def respond_to_missing?(name, include_private = false)
      atoms.key?(name.to_sym) || super
    end
  end
end
