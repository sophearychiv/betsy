require "test_helper"

describe Category do
  let(:category) { categories(:food) }
  let(:product1) { products(:product1) }
  let(:product2) { products(:product2) }

  it "must be valid" do
    value(category).must_be :valid?
  end

  describe "relations" do
    it "can have 0 products" do
      products = category.products

      expect(products.length).must_equal 0
    end

    it "can have 1 or more products" do
      category.products << product1
      category.products << product2

      expect(category.products.length).must_equal 2
      expect(category.products).must_include product1
      expect(category.products).must_include product2
      expect(product1.categories).must_include category
    end
  end

  describe "validations" do
    it "must have name" do
      category = Category.new

      expect(category.valid?).must_equal false
      expect(category.errors.messages).must_include :name
    end
  end
end
