require "test_helper"

describe ProductsController do
  let(:product) { products(:product1) }
  describe "new" do
    it "can get the new product page" do
      get new_product_path
    end
  end

  describe "show" do
    it "can show the product page" do
    end
  end

  describe "retire" do
    it "can retire a product" do
      id = product.id
      expect {patch retire_path(id)}.wont_change 'Product.count'
      product.reload
      must_respond_with :redirect
      must_redirect_to dashboard_path
      expect(flash[:success]).must_equal "#{product.name} has been retired."
      expect(product.active).must_equal false
    end
  end
end