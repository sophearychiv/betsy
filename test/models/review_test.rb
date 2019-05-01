require "test_helper"

describe Review do
  let(:review_one) { reviews(:review_one) }

  it "must be valid" do
    expect(review_one).must_be :valid?
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
    end

    it "accepts an integer rating between 1 and 5" do
      ratings = [1, 2, 3, 4, 5]

      ratings.each do |rating|
        review = Review.new(rating: rating, body: "So good!")
        expect(review.valid?).must_equal true
      end
    end

    it "must reject a rating that is not an integer between 1 and 5" do
      ratings = [0, 6, -5, 10, 5.1]

      ratings.each do |rating|
        review = Review.new(rating: rating, body: "My favorite tiny pizza by far!")
        expect(review.valid?).must_equal false
        expect(review.errors.messages).must_include :rating
      end
    end

    it "must have a body of text" do
      review = Review.new(rating: 3)

      expect(review.valid?).must_equal false
      expect(review.errors.messages).must_include :body
    end
  end
end
