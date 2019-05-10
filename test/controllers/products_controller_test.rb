require "test_helper"

describe ProductsController do
  let(:product) { products(:product1) }

  describe "index" do
    it "can show index page" do
      get products_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "can show the product page" do
      product = products(:product1)
      get product_path(product.id)
      must_respond_with :success
    end

    it "gives flash warning if the product is not active" do
      product = products(:product1)
      product.active = false
      product.save
      get product_path(product.id)

      expect(flash[:status]).must_equal :warning
      expect(flash[:result_text]).must_equal "#{product.name} is not active."
      must_respond_with :redirect
    end

    it "gives flash notice when the product is not found" do
      product_id = Product.last.id + 1
      get product_path(product_id)
      must_respond_with :redirect
      expect(flash[:status]).must_equal :error
      expect(flash[:result_text]).must_equal "Product does not exist."
    end
  end

  # describe "by_cat" do
  #   it "gets products by category" do
  #     category = categories(:food)
  #     get category_path(category.id)
  #     must_respond_with :success

  #     get products_path
  #     must_respond_with :success
  #   end
  # end

  describe "new" do
    it "can get the new product page" do
      get new_product_path
      must_respond_with :success
    end
  end

  describe "edit" do
    it "can get edit page" do
      product = products(:product1)
      get edit_product_path(product.id)
      must_respond_with :success
    end

    it "gives flash notice when the product does not exist" do
      product_id = Product.last.id + 1
      get edit_product_path(product_id)
      must_respond_with :redirect
      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_equal "Product not found."
    end
  end

  describe "retire" do
    it "can retire a product" do
      id = product.id
      expect { patch retire_path(id) }.wont_change "Product.count"
      product.reload
      must_respond_with :redirect
      must_redirect_to dashboard_path
      expect(flash[:success]).must_equal "#{product.name} has been retired."
      expect(product.active).must_equal false
    end
  end
end
