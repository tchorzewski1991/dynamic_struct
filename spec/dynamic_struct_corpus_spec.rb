require 'spec_helper'

RSpec.describe DynamicStruct::Corpus do
  subject { described_class }

  # Constructor refers to flexible subject entity builder
  let(:constructor) do
    ->(arguments = nil) do
      arguments.nil? && subject.new || subject.new(arguments)
    end
  end

  describe 'initialization' do
    context 'when arguments missing' do
      let(:corpus) { constructor.() }

      it 'raises ArgumentError' do
        expect { corpus }.to raise_error(ArgumentError)
      end
    end

    context 'when arguments present' do
      let(:corpus) { constructor.(key: 'value') }

      it 'defines atoms ivar' do
        expect(corpus.instance_variable_defined?(:@atoms)).to eq(true)
      end

      it 'is expected atoms ivar to be an instance of Hash' do
        expect(corpus.instance_variable_get(:@atoms)).to be_an(Hash)
      end

      it 'depends on #verify private instance method' do
        is_expected.to call('verify').inside('new')
      end

      it 'depends on #assign private instance method' do
        is_expected.to call('assign').inside('new')
      end
    end
  end

  describe 'custom instance methods' do
    describe '#atoms' do
      let(:corpus) { constructor.(key: 'value') }

      it 'defines #atoms as private attribute reader' do
        expect(subject.private_method_defined?(:atoms)).to eq(true)
      end
    end

    describe '#atoms?' do
      let(:empty_corpus) { constructor.({}) }
      let(:filled_corpus) { constructor.(key: 'value') }

      it 'defines #atoms? as public instance method' do
        expect(subject.public_method_defined?(:atoms?)).to eq(true)
      end

      it 'returns false for empty corpus' do
        expect(empty_corpus.atoms?).to eq(false)
      end

      it 'returns true for filled corpus' do
        expect(filled_corpus.atoms?).to eq(true)
      end
    end

    describe '#inspect' do
      it 'defines #inspect as public instance method' do
        expect(subject.public_method_defined?(:inspect)).to eq(true)
      end

      it 'has arity of zero' do
        expect(subject.instance_method(:inspect).arity).to eq(0)
      end

      context 'when atoms present' do
        let(:corpus) { constructor.(key: :value) }

        it 'matches schema for corpus with atoms' do
          expect(corpus.inspect).to match(/<DynamicStruct::Corpus key=:value>/)
        end
      end

      context 'when atoms missing' do
        let(:corpus) { constructor.({}) }

        it 'matches schema for corpus without atoms' do
          expect(corpus.inspect).to match(/<DynamicStruct::Corpus>/)
        end
      end
    end

    describe '#verify' do
      let(:corpus) { constructor.({}) }

      it 'defines #verify as private instance method' do
        expect(subject.private_method_defined?(:verify)).to eq(true)
      end

      it 'has arity of one' do
        expect(subject.instance_method(:verify).arity).to eq(1)
      end

      it 'returns true for non-empty Hash argument' do
        expect(corpus.send(:verify, key: 'value')).to eq(true)
      end

      it 'returns false for empty Hash argument' do
        expect(corpus.send(:verify, {})).to eq(false)
      end

      it 'returns false for argument other than Hash' do
        expect(corpus.send(:verify, [])).to eq(false)
      end
    end

    describe '#assign' do
      let(:corpus) { constructor.({}) }

      it 'defines #assign as private instance method' do
        expect(subject.private_method_defined?(:assign)).to eq(true)
      end

      it 'has arity of one' do
        expect(subject.instance_method(:assign).arity).to eq(1)
      end

      it 'refutes arguments which wont respond to #each method' do
        expect { corpus.send(:assign, '') }.to raise_error(NoMethodError)
      end

      it 'depends on #new_entry private instance method' do
        is_expected.to call('new_entry').inside('assign')
      end
    end

    describe '#new_entry -' do
      let(:corpus) { constructor.({}) }

      it 'defines #new_entry as private instance method' do
        expect(subject.private_method_defined?(:new_entry)).to eq(true)
      end

      it 'has arity of two' do
        expect(subject.instance_method(:new_entry).arity).to eq(2)
      end

      it 'setups new key-value pair for atoms ivar' do
        # before
        expect(corpus.atoms?).to eq(false)

        corpus.send(:new_entry, :key, 'value')

        # after
        expect(corpus.atoms?).to eq(true)
      end

      it 'symbilizes key argument for each new entry' do
        corpus.send(:new_entry, 'key', 'value')
        expect(corpus.instance_variable_get(:@atoms).keys).to include(:key)
      end
    end

    describe '#method_missing' do
      let(:corpus) { constructor.(first: 'first') }

      it 'defines #method_missing as private instance method' do
        expect(subject.private_method_defined?(:method_missing)).to eq(true)
      end

      it 'returns value for existing atoms key' do
        expect(corpus.first).to eq('first')
      end

      it 'returns nil for non-existing atoms key' do
        expect(corpus.second).to eq(nil)
      end

      it 'sets value of non-existing atoms key' do
        corpus.second = 'second'
        expect(corpus.second).to eq('second')
      end
    end

    describe '#respond_to_missing?' do
      let(:corpus) { constructor.(first: 'first') }

      it 'defines #respond_to_missing? as private instance method' do
        expect(subject.private_method_defined?(:respond_to_missing?)).to eq(true)
      end

      it 'returns true for existing atoms key' do
        expect(corpus.respond_to?(:first)).to eq(true)
      end

      it 'returns true for predefined instance method' do
        expect(corpus.respond_to?(:atoms?)).to eq(true)
      end

      it 'returns false for non-existing atoms key' do
        expect(corpus.respond_to?(:second)).to eq(false)
      end
    end

    describe '#[]' do
      let(:corpus) { constructor.(first: 'first') }

      it 'defines #[] as public instance method' do
        expect(subject.public_method_defined?(:[])).to eq(true)
      end

      it 'returns value for existing key' do
        expect(corpus[:first]).to eq('first')
      end

      it 'return nil for missing key' do
        expect(corpus[:missing]).to be_nil
      end

      it 'accepts both symbol and string' do
        expect(corpus['first']).to eq('first')
      end
    end

    describe '#[]=' do
      let(:corpus) { constructor.({}) }

      it 'defines #[]= as public instance method' do
        expect(subject.public_method_defined?(:[]=)).to eq(true)
      end

      it 'sets new entry for missing key' do
        # before #[]= call
        expect(corpus[:first]).to eq(nil)

        corpus[:first] = 'first'

        # after #[]= call
        expect(corpus[:first]).to eq('first')
      end

      it 'accepts both symbol and string' do
        corpus[:first] = 'first' and corpus['second'] = 'second'
        expect([corpus[:first], corpus[:second]]).to eq(%w(first second))
      end
    end

    describe '#eql?' do
      let(:corpus) { constructor.({}) }

      it 'defines #eql? as public instance method' do
        expect(subject.public_method_defined?(:eql?)).to eq(true)
      end

      it 'has arity of one' do
        expect(subject.method(:eql?).arity).to eq(1)
      end

      it 'depends on #hash public instance method' do
        is_expected.to(
          call('hash').inside('eql?') do |host|
            host.argument = corpus
          end
        )
      end
    end

    describe '#each' do
      let(:corpus) { constructor.(one: 'two', three: 'four') }

      it 'defines #each as public instance method' do
        expect(subject.public_method_defined?(:each)).to eq(true)
      end

      it 'has arity of 0' do
        expect(subject.instance_method(:each).arity).to eq(0)
      end

      context 'when block' do
        it 'returns corpus after block execution' do
          expect(corpus.each { |key, value| [key, value] }).to eq(corpus)
        end

        it 'yields each key-value pair to the block' do
          result = [] and begin
            corpus.each { |key, _| result << key }
          end

          expect(result).to contain_exactly(:one, :three)
        end
      end

      context 'when no block' do
        it 'returns explicit enumerator' do
          expect(corpus.each).to be_an(Enumerator)
        end
      end
    end
  end
end
