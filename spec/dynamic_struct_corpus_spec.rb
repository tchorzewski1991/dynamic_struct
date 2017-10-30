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
end
