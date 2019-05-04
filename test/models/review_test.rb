require "test_helper"

describe Review do
  let(:review_one) { reviews(:review_one) }
  let(:product) { products(:product1) }

  it "must be valid" do
    expect(review_one.valid?).must_equal true
  end

  describe "relations" do
    it "has a product" do
      review_one.must_respond_to :product
      review_one.product.must_be_kind_of Product
    end
  end

  describe "validations" do
    it "requires a rating" do
      review = Review.new(body: "Amazing!")

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :rating
      expect(review.errors.messages[:rating]).must_include "can't be blank"
    end

    it "accepts an integer rating between 1 and 5" do
      ratings = [1, 2, 3, 4, 5]

      ratings.each do |rating|
        review = Review.new(rating: rating, body: "So good!", product: product)
        expect(review.valid?).must_equal true
      end
    end

    it "must reject a rating that is not an integer between 1 and 5" do
      ratings = [0, 6, -5, 10]

      ratings.each do |rating|
        review = Review.new(rating: rating, body: "My favorite tiny pizza by far!", product: product)
        expect(review.valid?).must_equal false
        expect(review.errors.messages).must_include :rating
        expect(review.errors.messages[:rating]).must_equal ["must be a number between 1 and 5"]
      end
    end

    it "must have a body of text" do
      review = Review.new(rating: 3)

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :body
      expect(review.errors.messages[:body]).must_equal ["can't be blank"]
    end
  end
end
