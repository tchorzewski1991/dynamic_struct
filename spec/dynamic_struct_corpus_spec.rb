require 'spec_helper'

RSpec.describe DynamicStruct::Corpus do
  subject { described_class }
  let(:arguments) { { key: 'value' } }
  let(:corpus) { subject.new(arguments) }

  describe 'initialize -' do
    it 'expects to initialize atoms ivar' do
      expect(corpus.instance_variable_defined?(:@atoms)).to eq(true)
    end

    context 'when arguments missing -' do
      it 'expects to raise ArgumentError' do
        expect { subject.new }.to raise_error(ArgumentError)
      end
    end

    context 'when arguments present -' do
      it 'expects to defined atoms ivar' do
        expect(corpus.instance_variable_defined?(:@atoms)).to eq(true)
      end

      it 'expects to set atoms ivar with empty Hash' do
        expect(corpus.instance_variable_get(:@atoms).keys).to be_empty
      end
    end
  end

  describe 'custom instance methods -' do
    describe '#atoms -' do
      it 'expects to define #atoms as private attribute reader' do
        expect(subject.private_method_defined?(:atoms)).to eq(true)
      end

      it 'refutes to call #atoms from public interface' do
        expect { corpus.atoms }.to raise_error(NoMethodError)
      end
    end

    describe '#atoms? -' do
      it 'expects to define #atoms? as public instance method' do
        expect(subject.public_method_defined?(:atoms?)).to eq(true)
      end

      it 'expects to return false for empty atoms ivar' do
        expect(corpus.atoms?).to eq(false)
      end
    end

    describe '#inspect -' do
      it 'expects to define #inspect as public instance method' do
        expect(subject.public_method_defined?(:inspect)).to eq(true)
      end

      context 'when atoms present -' do
        it 'expects to match schema for corpus with atoms' do
          corpus.instance_variable_set(:@atoms, { key: :value })
          expect(corpus.inspect).to match(/<DynamicStruct::Corpus key=:value>/)
        end
      end

      context 'when atoms missing -' do
        it 'expects to match schema for corpus without atoms' do
          expect(subject.new({}).inspect).to match(/<DynamicStruct::Corpus>/)
        end
      end
    end
  end
end
