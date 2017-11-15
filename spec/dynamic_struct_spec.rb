require 'spec_helper'

RSpec.describe DynamicStruct do
  let(:subject) { described_class }

  it 'has a version number' do
    expect(subject::VERSION).not_to be nil
  end

  it 'expects subject to be a module' do
    expect(subject.class).to be(Module)
  end

  describe 'constants -' do
    it 'expects subject to define Corpus constant' do
      expect(subject.const_defined?(:Corpus)).to eq(true)
    end
  end

  describe 'custom methods -' do
    context '#construct -' do
      it 'expects subject respond to context' do
        expect(subject.respond_to?(:construct)).to be_truthy
      end

      it 'expects context to be a singleton method' do
        expect(subject.singleton_class.method_defined?(:construct)).to eq(true)
      end

      it 'expects context to return instance of DynamicStruct::Corpus' do
        expect(subject.construct.class).to be(DynamicStruct::Corpus)
      end
    end
  end
end
