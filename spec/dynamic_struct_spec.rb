require 'spec_helper'

RSpec.describe DynamicStruct do
  let(:subject) { described_class }

  it 'has a version number' do
    expect(subject::VERSION).not_to be nil
  end

  it 'expects subject to be a module' do
    expect(subject.class).to be(Module)
  end

  it 'defines Corpus constant' do
    expect(subject.const_defined?(:Corpus)).to eq(true)
  end

  describe 'custom methods' do
    context '#construct -' do
      it 'is expected subject respond to context' do
        expect(subject.respond_to?(:construct)).to be_truthy
      end

      it 'returns instance of DynamicStruct::Corpus' do
        expect(subject.construct.class).to be(DynamicStruct::Corpus)
      end

      # As arguments are optional
      it 'has arity of -1' do
        expect(subject.singleton_method(:construct).arity).to eq(-1)
      end

      context 'when arguments given' do
        it 'sets arguments from block only' do
          struct = subject.construct { |s| s.i = 'j' }
          expect(struct.i).to eq('j')
        end

        it 'sets arguments from hash only' do
          struct = subject.construct(i: 'j')
          expect(struct.i).to eq('j')
        end

        it 'sets arguments from both when mixed' do
          struct = subject.construct(i: 'j') { |s| s.k = 'l' }
          expect([struct.i, struct.k]).to eq(%w(j l))
        end

        it 'is expected to prioritize arguments from hash' do
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

      context 'when arguments missing' do
        it 'returns empty instance of DynamicStruct::Corpus' do
          expect(subject.construct.atoms?).to eq(false)
        end
      end
    end
  end
end
