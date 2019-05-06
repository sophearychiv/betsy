require "test_helper"

describe Orderitem do
  let(:orderitem) { orderitems(:item1) }
  let(:product1) { products(:product1) }
  let(:product2) { products(:product2) }

  it "must be valid" do
    value(orderitem).must_be :valid?
  end

  describe "relationships" do
    it "has an order" do
      orderitem.must_respond_to :order
      orderitem.order.must_be_kind_of Order
    end

    it "has a product" do
      orderitem.must_respond_to :product
      orderitem.product.must_be_kind_of Product
    end
  end

  describe "validations" do
    it "valid with quantity" do
      expect(orderitem).must_be :valid?
    end

    it "invalid without quantity" do
      orderitem.quantity = nil

      expect(orderitem).wont_be :valid?
      expect(orderitem.errors.messages).must_include :quantity
      expect(orderitem.errors.messages[:quantity]).must_equal ["can't be blank", "is not a number"]
    end

    it "invalid when the quantity is less than or equal to zero or nil" do
      quantities = [-1, 0]

      quantities.each do |quantity|
        orderitem.quantity = quantity

        expect(orderitem).wont_be :valid?
        expect(orderitem.errors.messages).must_include :quantity
        expect(orderitem.errors.messages[:quantity]).must_equal ["must be greater than 0"]
      end
    end
  end

  describe "custom methods" do
    describe "in_stock?" do
      it "must return the item quantity if it is less than the stock quantity" do
        product2.orderitems << orderitem
        quantity = orderitem.adjust_quantity

        expect(quantity).must_equal orderitem.quantity
      end

      it "must return the stock quantity if it is less than the item quantity" do
        orderitem.quantity = 10
        orderitem.save

        quantity = orderitem.adjust_quantity
        expect(quantity).must_equal product1.stock
      end

      it "if item quantity and stock quantity is the same, must return that value" do
        quantity = orderitem.adjust_quantity

        expect(quantity).must_equal orderitem.quantity
        expect(quantity).must_equal product1.stock
      end
    end
  end
end
