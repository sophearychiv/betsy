require "test_helper"

describe Category do
  let(:category) { Category.new }

  it "must be valid" do
    value(category).must_be :valid?
  end

  describe "relations" do
    it "has many products" do
    end

    it "belongs to many products" do
    end
  end

  describe "validations" do
  end
end
