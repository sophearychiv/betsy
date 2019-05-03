require "test_helper"

describe ReviewsController do
  let(:product) { products(:product1) }

  describe "new" do
    it "should get the new review form for an existing product" do
      get new_product_review_path(product.id)

      must_respond_with :success
    end
  end

  it "should get create" do
  end
end
