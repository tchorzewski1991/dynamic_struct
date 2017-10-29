require "spec_helper"

RSpec.describe DynamicStruct do
  it "has a version number" do
    expect(DynamicStruct::VERSION).not_to be nil
  end
end
