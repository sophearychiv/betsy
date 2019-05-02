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

    it "requires an email" do
      order.email = nil
      valid_order = order.valid?
      expect(valid_order).must_equal false
      expect(order.errors.messages).must_include :email
      expect(order.errors.messages[:email]).must_equal ["can't be blank"]
    end

    it "requires an address" do
      order.address = nil
      valid_order = order.valid?
      expect(valid_order).must_equal false
      expect(order.errors.messages).must_include :address
      expect(order.errors.messages[:address]).must_equal ["can't be blank"]
    end

    it "requires cc" do
      order.cc = nil
      valid_order = order.valid?
      expect(valid_order).must_equal false
      expect(order.errors.messages).must_include :cc
      expect(order.errors.messages[:cc]).must_equal ["can't be blank"]
    end

    it "requires csv" do
      order.csv = nil
      valid_order = order.valid?
      expect(valid_order).must_equal false
      expect(order.errors.messages).must_include :csv
      expect(order.errors.messages[:csv]).must_equal ["can't be blank"]
    end

    it "requires expiration_date" do
      order.expiration_date = nil
      valid_order = order.valid?
      expect(valid_order).must_equal false
      expect(order.errors.messages).must_include :expiration_date
      expect(order.errors.messages[:expiration_date]).must_equal ["can't be blank"]
    end
  end

  describe "Relationships" do
    it "can have 1 or many orderitems" do
      order_item1 = orderitems(:item1)
      order_item2 = orderitems(:item2)

      order.orderitems << order_item1
      order.orderitems << order_item2

      expect(order.orderitems).must_include order_item1
      expect(order.orderitems).must_include order_item2

      order.orderitems.each do |orderitem|
        expect(orderitem).must_be_an_instance_of Orderitem
      end
    end
  end
end
