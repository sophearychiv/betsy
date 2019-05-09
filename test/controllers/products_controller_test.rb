require "test_helper"

describe ProductsController do
  let(:product) { products(:product1) }
  describe "new" do
    it "can get the new product page" do
      get new_product_path
      must_respond_with :success
    end
  end

  describe "index" do
    it "can get the index page" do
      get products_path
      must_respond_with :success
    end
  end

  describe "retire" do
    it "can retire a product" do
      id = product.id
      expect { patch retire_path(id) }.wont_change "Product.count"
      product.reload
      must_respond_with :redirect
      must_redirect_to products_path
      expect(flash[:success]).must_equal "#{product.name} has been retired."
      expect(product.active).must_equal false
    end
  end
end
