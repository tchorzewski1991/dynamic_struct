require 'spec_helper'

RSpec.describe DynamicStruct::Corpus do
  subject { described_class }

  # Constructor refers to flexible subject entity builder
  let(:constructor) do
    ->(arguments = nil) do
      arguments.nil? && subject.new || subject.new(arguments)
    end
  end

  # Inspector refers to observer for messages sent to entity
  # during subject initialization
  let(:inspector) do
    ->(name, arguments = nil) do
      klass = Class.new(subject) do
        attr_accessor :induction
        class_eval %(
          def #{name}(*)
            self.induction = true
            super
          end
        )
      end

      result = begin
        instance = klass.new(arguments || {})
        instance.induction & true
      rescue NoMethodError
        false
      end

      result
    end
  end

  describe 'initialize -' do
    context 'when arguments missing -' do
      let(:corpus) { constructor.() }

      it 'expects to raise ArgumentError' do
        expect { corpus }.to raise_error(ArgumentError)
      end
    end

    context 'when arguments present -' do
      let(:corpus) { constructor.(key: 'value') }

      it 'expects to define atoms ivar' do
        expect(corpus.instance_variable_defined?(:@atoms)).to eq(true)
      end

      it 'expects atoms ivar to be an instance of Hash' do
        expect(corpus.instance_variable_get(:@atoms)).to be_an(Hash)
      end

      it 'expects to call #verify private instance method' do
        expect(inspector.call('verify')).to eq(true)
      end

      it 'expects to call #assign private instance method' do
        expect(inspector.call('assign', key: 'value')).to eq(true)
      end
    end
  end

  describe 'custom instance methods -' do
    describe '#atoms -' do
      let(:corpus) { constructor.(key: 'value') }

      it 'expects to define #atoms as private attribute reader' do
        expect(subject.private_method_defined?(:atoms)).to eq(true)
      end

      it 'expects to return nil when invoked from public interface' do
        expect(corpus.atoms).to eq(nil)
      end
    end

    describe '#atoms? -' do
      let(:empty_corpus) { constructor.({}) }
      let(:filled_corpus) { constructor.(key: 'value') }

      it 'expects to define #atoms? as public instance method' do
        expect(subject.public_method_defined?(:atoms?)).to eq(true)
      end

      it 'expects to return false for empty corpus' do
        expect(empty_corpus.atoms?).to eq(false)
      end

      it 'expects to return true for filled corpus' do
        expect(filled_corpus.atoms?).to eq(true)
      end
    end

    describe '#inspect -' do
      it 'expects to define #inspect as public instance method' do
        expect(subject.public_method_defined?(:inspect)).to eq(true)
      end

      context 'when atoms present -' do
        let(:corpus) { constructor.(key: :value) }

        it 'expects to match schema for corpus with atoms' do
          expect(corpus.inspect).to match(/<DynamicStruct::Corpus key=:value>/)
        end
      end

      context 'when atoms missing -' do
        let(:corpus) { constructor.({}) }

        it 'expects to match schema for corpus without atoms' do
          expect(corpus.inspect).to match(/<DynamicStruct::Corpus>/)
        end
      end
    end

    describe '#verify -' do
      let(:corpus) { constructor.({}) }

      it 'expects to define #verify as private instance method' do
        expect(subject.private_method_defined?(:verify)).to eq(true)
      end

      context 'when arguments present -' do
        it 'expects to return true for Hash argument' do
          expect(corpus.send(:verify, key: 'value')).to eq(true)
        end

        it 'expects to return false for empty Hash argument' do
          expect(corpus.send(:verify, {})).to eq(false)
        end

        it 'expects to return false for argument other than Hash' do
          expect(corpus.send(:verify, [])).to eq(false)
        end
      end

      context 'when arguments missing -' do
        it 'expects to raise ArgumentError for missing arguments' do
          expect { corpus.send(:verify) }.to raise_error(ArgumentError)
        end
      end
    end

    describe '#assign -' do
      let(:corpus) { constructor.({}) }

      it 'expects to define #assign as private instance method' do
        expect(subject.private_method_defined?(:assign)).to eq(true)
      end

      context 'when arguments present -' do
        it 'refutes arguments which wont respond to #each method' do
          expect { corpus.send(:assign, '') }.to raise_error(NoMethodError)
        end

        it 'expects to call #new_entry private instance method' do
          expect(inspector.call('new_entry', key: 'value')).to eq(true)
        end
      end

      context 'when arguments missing -' do
        it 'expects to raise ArgumentError for missing arguments' do
          expect { corpus.send(:assign) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
