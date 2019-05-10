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

  describe "new" do
    it "can get the new product page" do
      perform_login
      get new_product_path
      must_respond_with :success
    end
  end

  describe "edit" do
    it "can get edit page" do
      perform_login

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
      perform_login

      id = product.id
      expect { patch retire_path(id) }.wont_change "Product.count"
      product.reload
      must_respond_with :redirect
      must_redirect_to dashboard_path
      expect(flash[:success]).must_equal "#{product.name} has been retired."
      expect(product.active).must_equal false
    end
  end

  describe "create" do
    it "can create a new product" do
      perform_login
      input_product = {
        product: {
          name: "test name",
          price: 100,
          stock: 10,
        },
      }
      expect {
        post products_path, params: input_product
      }.must_change "Product.count", 1

      product = Product.find_by(name: input_product[:product][:name])

      must_respond_with :redirect
      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_equal "Successfully created #{product.name}"
    end

    it "gives notice when the product cannot be created" do
      perform_login
      input_product = {
        product: {
          name: nil,
          price: 100,
          stock: 10,
        },
      }

      expect {
        post products_path, params: input_product
      }.wont_change "Product.count"

      expect(flash[:status]).must_equal :error
      expect(flash[:result_text]).must_equal "Experiencing an issue with creating the product."
      must_respond_with :bad_request
    end

    it "gives flash notice when user is not signed in" do
      input_product = {
        product: {
          name: "test name",
          price: 100,
          stock: 10,
        },
      }
      expect {
        post products_path, params: input_product
      }.wont_change "Product.count"

      expect(flash[:status]).must_equal :error
      expect(flash[:result_text]).must_equal "You must be logged in to perform this action."
      must_respond_with :redirect
    end
  end

  describe "update" do
    it "can update the product" do
      perform_login

      input_product = {
        product: {
          name: "test name",
          price: 100,
          stock: 10,
        },
      }

      product = products(:product1)

      expect {
        patch product_path(product.id), params: input_product
      }.wont_change "Product.count"

      product.reload
      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_equal "Successfully updated #{product.name}"
      must_respond_with :redirect
    end

    it "gives flash error if the product cannot be updated" do
      perform_login
      input_product = {
        product: {
          name: nil,
          price: 100,
          stock: 10,
        },
      }
      product = products(:product1)

      expect {
        patch product_path(product.id), params: input_product
      }.wont_change "Product.count"

      expect(flash[:status]).must_equal :error
      expect(flash[:result_text]).must_equal "Failed to update"
      must_respond_with :bad_request
    end
  end
end
