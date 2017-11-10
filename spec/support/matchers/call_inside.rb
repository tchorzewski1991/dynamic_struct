RSpec::Matchers.define :call do |target|
  # The main responsibility of #call(...).inside(...) matcher is to create
  # flexible mechanism for observing 'target' method invocation during
  # execution of 'host' method. There is a lot of metaprogramming in
  # here but the point is to understand subject mocking and host mocking.

  # Examples of usage
  #
  # When #another method has no arguments:
  #
  # it 'expects to call #one method inside #another method' do
  #   is_expected.to call('one').inside('another')
  # end
  #
  # When #another method expects arguments:
  #
  # it 'expects to call #one method inside #another method' do
  #   is_expected.to(
  #     call('one').inside('another') do
  #       |host| host.argument = argument
  #     end
  #   )
  # end

  # Mock subject
  #
  # Argument used by RSpec::Matchers#match is class that we want to describe.
  # First step is to create 'Class' class object with inheritance involved.
  # Our 'mock' basically is mimic of our subject class. As we defined that
  # 'mimic' class we can do with that class whatever we want, as it is safe
  # operation. As all operation are kind of safe operations we can redefine
  # method, that we want to inspect.

  # We need to take consideration on three cases:
  #
  # 1) There is no such a method:
  #    Case will be rescued and indication will be setup to false.
  #
  # 2) Method has been found, but that method call depends on entry arguments:
  #    Case will be rescued and indication will be setup to false
  #
  # 3) Method has been found and called correctly:
  #    Indication will be setup to true

  def mock_subject(subject, target)
    Class.new(subject) do
      attr_reader :induction

      class_eval %(
        def #{target}(*)
          begin
            result = super
          rescue ArgumentError
            nil
          rescue NoMethodError
            @induction = false
          ensure
            instance_variable_defined?(:@induction) || @induction = true
            result
          end
        end
      )
    end
  end

  # Mock host

  # Problem occurs when we need to call our 'host' method with arguments.
  # There needs to be some distinction between when we have some arguments for
  # our host method, and when method is called without any argument. The easiest
  # way will be to create another standalone 'Class' class object with
  # corresponding accessors.

  def mock_host
    Class.new do
      attr_reader :name
      attr_accessor :argument

      def initialize(name)
        @name = name
        yield(self) if block_given?
      end
    end
  end

  match do |subject|
    subject = mock_subject(subject, target)
    instance = subject.new(key: 'value')

    (instance.induction & true) || begin
      instance
        .tap do |s|
          @host.argument ?
          s.send(@host.name, @host.argument) : s.send(@host.name)
        end
        .induction & true
    end
  end

  chain :inside do |host, &block|
    @host = mock_host.new(host, &block)
  end
end
