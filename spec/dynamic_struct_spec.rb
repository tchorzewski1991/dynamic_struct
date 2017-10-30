require 'spec_helper'

RSpec.describe DynamicStruct do
  let(:subject) { described_class }

  it "has a version number" do
    expect(subject::VERSION).not_to be nil
  end

  it 'expects subject to be a module' do
    expect(subject.class).to be(Module)
  end
end
