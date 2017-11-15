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

      it 'expects to has arity of -1 as arguments are optional' do
        expect(subject.singleton_method(:construct).arity).to eq(-1)
      end

      context 'for given arguments -' do
        it 'expects to set arguments from block only' do
          struct = subject.construct { |s| s.i = 'j' }
          expect(struct.i).to eq('j')
        end

        it 'expects to set arguments from hash only' do
          struct = subject.construct(i: 'j')
          expect(struct.i).to eq('j')
        end

        it 'expects to set arguments from both when mixed' do
          struct = subject.construct(i: 'j') { |s| s.k = 'l' }
          expect([struct.i, struct.k]).to eq(%w(j l))
        end

        it 'expects to prioritize arguments from hash' do
          struct = subject.construct(i: 'j') { |s| s.i || s.k = 'l' }
          expect([struct.i, struct.k]).to eq(['j', nil])
        end

        it 'allows for block manipulation with public instance methods' do
          struct = subject.construct(i: 'j') do |s|
            s.atoms? || s.m = 'n'
            s['k'] = 'l'
          end

          expect([struct.i, struct.k, struct.m]).to eq(['j', 'l', nil])
        end

        it 'ignores block argument without block variable' do
          struct = subject.construct { (s.i = 'j') rescue nil }
          expect(struct.i).to eq(nil)
        end
      end

      context 'for missing arguments -' do
        it 'expects to return empty instance of DynamicStruct::Corpus' do
          expect(subject.construct.atoms?).to eq(false)
        end
      end
    end
  end
end
