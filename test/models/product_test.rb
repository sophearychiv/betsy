require "test_helper"

describe Product do
  let(:product) { products(:product1) }

  it "must be valid" do
    validity = product.valid?
    expect(validity).must_equal true
    end

  it 'has required fields' do
    fields = %i(name price merchant_id stock description active photo_url)

    fields.each do |field|
      expect(product).must_respond_to field
    end
  end

  it "returns its average rating" do
    expect(product.average_rating).must_equal 5
  end

  it "returns not yet rated if there are no ratings" do
    expect(products(:product3).average_rating).must_equal 'Not yet rated'
  end
end
