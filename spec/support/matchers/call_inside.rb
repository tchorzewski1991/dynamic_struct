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

  match do |subject|
    subject = mock_subject(subject, target)
    instance = subject.new({ key: 'value' })

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
