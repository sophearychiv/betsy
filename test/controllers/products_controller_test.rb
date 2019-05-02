require "test_helper"

describe ProductsController do
  let(:product) { products(:product1) }

  describe "new" do
    it "can get the new product page" do
      get new_product_path
    end
  end

  describe "retire" do
    it "can retire a product" do
      id = product.id
      name = product.id

      expect {patch retire_path(id)}.must_change 'Product.active_products.count', -1
      must_respond_with :redirect
      must_redirect_to products_path
      expect(Product.find_by(id: id).active).must_equal false
    end
  end
end