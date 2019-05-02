require "test_helper"

describe Order do
  let(:order) { orders(:one) }

  describe "Validations" do
    it "must be valid" do
      order = orders(:one)
      valid_order = order.valid?
      expect(valid_order).must_equal true
    end
  end
end
