require "test_helper"


describe Orderitem do
  let(:orderitem) { Orderitem.new }
  let(:orderitem_1) { orderitems(:orderitem_1) }

  describe "valid" do
    it "must be valid" do
      value(orderitem).must_be :valid?
    end
  end
end
