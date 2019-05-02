require "test_helper"

describe Order do
  let(:order) { orders(:one) }

  it "must be valid" do
    order = orders(:one)
    valid_order = order.valid?
    expect(valid_order).must_equal true
  end

  describe "Validations" do
    it "requires user's name" do
      order.name = nil
      valid_order = order.valid?
      expect(valid_order).must_equal false
      expect(order.errors.messages).must_include :name
      expect(order.errors.messages[:name]).must_equal ["can't be blank"]
    end
  end
end
