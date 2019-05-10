require "test_helper"

describe ReviewsController do
  let(:product) { products(:product1) }
  let(:review_hash) { { "review": { rating: 2, body: "Perfectly tiny!" } } }

  describe "new" do
    it "can get the new review form for an existing product" do
      get new_product_review_path(product.id)

      must_respond_with :success
    end
  end

  describe "create" do
    it "must create a new review for an existing product" do
      # review_hash = {
      #   "review": {
      #     rating: 2,
      #     body: "Perfectly tiny!",
      #   },
      # }

      expect {
        post product_reviews_path(product.id), params: review_hash
      }.must_change "Review.count", 1

      new_review = Review.find_by(body: review_hash[:review][:body])

      expect(new_review.rating).must_equal review_hash[:review][:rating]
      must_respond_with :redirect
      must_redirect_to product_path(product.id)
      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_equal "Thank you for your feedback"
    end

    it "must redirect to product index page for a non-existing product" do
      invalid_product_id = -1
      # review_hash = {
      #   "review": {
      #     rating: 2,
      #     body: "Perfectly tiny!",
      #   },
      # }

      expect {
        post product_reviews_path(invalid_product_id), params: review_hash
      }.wont_change "Review.count"

      must_respond_with :redirect
      must_redirect_to products_path
      expect(flash[:status]).must_equal :error
      expect(flash[:result_text]).must_equal "An itsy problem occurred: Product not found"
    end

    it "renders new form if review is not created" do
      invalid_review_hash = {
        "review": {
          body: "Perfectly tiny!",
        },
      }

      expect {
        post product_reviews_path(product.id), params: invalid_review_hash
      }.wont_change "Review.count"

      must_respond_with :bad_request
      expect(flash[:status]).must_equal :error
      expect(flash[:result_text]).must_equal "An itsy problem occurred: Could not process feedback"
    end

    it "must redirect if user is trying to leave a review for their own product" do
      user = perform_login
      product = user.products.find_by(name: "teeny tiny pencil box")

      expect {
        post product_reviews_path(product.id), params: review_hash
      }.wont_change "Review.count"

      must_respond_with :redirect
      must_redirect_to dashboard_path(user.id)
      expect(flash[:status]).must_equal :error
      expect(flash[:result_text]).must_equal "An itsy problem occurred: You can't rate your own products"
    end
  end
end
