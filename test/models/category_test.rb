require "test_helper"

describe Category do
  let(:category) { categories(:food) }

  it "must be valid" do
    value(category).must_be :valid?
  end

  describe "relations" do
    it "can have 0 products" do
      products = category.products

      expect(products.length).must_equal 0
    end

    it "can have 1 or more products" do
    end
  end

  describe "validations" do
  end
end
