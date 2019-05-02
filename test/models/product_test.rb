require "test_helper"

describe Product do
  let(:product) { products(:product1) }

  it "returns not yet rated if there are no ratings" do
    expect(product).average_rating.must_equal 'Not yet rated'
  end

  it "must be valid" do
    value(product).must_be :valid?
  end

  it 'has required fields' do
    fields = i%(name price merchant_id stock description active photo_url)

    fields.each do |field|
      expect(product).must_respond_to field
    end
  end
end
