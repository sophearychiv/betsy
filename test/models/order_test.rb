require "test_helper"

describe Order do
  let(:order) { orders(:one) }

  it "must be valid" do
    order = orders(:one)
    valid_order = order.valid?
    expect(valid_order).must_equal true
  end

  describe "Validations" do
    describe "if status is nil" do
      it "doesn't require name if status is nil" do
        order.name = nil
        order.status = nil
        valid_order = order.valid?
        expect(valid_order).must_equal true
        # expect(order.errors.messages).must_include :name
        # expect(order.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "doesn't require an email if status is nil" do
        order.email = nil
        order.status = nil
        valid_order = order.valid?
        expect(valid_order).must_equal true
        # expect(order.errors.messages).must_include :email
        # expect(order.errors.messages[:email]).must_equal ["can't be blank"]
      end

      it "doesn't require an address if status is nil" do
        order.address = nil
        order.status = nil
        valid_order = order.valid?
        expect(valid_order).must_equal true
        # expect(order.errors.messages).must_include :address
        # expect(order.errors.messages[:address]).must_equal ["can't be blank"]
      end

      it "doesn't require cc if status is nil" do
        order.cc = nil
        order.status = nil
        valid_order = order.valid?
        expect(valid_order).must_equal true
        # expect(order.errors.messages).must_include :cc
        # expect(order.errors.messages[:cc]).must_equal ["can't be blank"]
      end

      it "doesn't require csv if status is nil" do
        order.csv = nil
        order.status = nil
        valid_order = order.valid?
        expect(valid_order).must_equal true
        # expect(order.errors.messages).must_include :csv
        # expect(order.errors.messages[:csv]).must_equal ["can't be blank"]
      end

      it "doesn't requires expiration_date if status is nil" do
        order.expiration_date = nil
        order.status = nil
        valid_order = order.valid?
        expect(valid_order).must_equal true
        # expect(order.errors.messages).must_include :expiration_date
        # expect(order.errors.messages[:expiration_date]).must_equal ["can't be blank"]
      end
    end

    describe "if status is not nil" do
      it "requires name if status is not nil" do
        order.name = nil
        # order.status == "complete"
        valid_order = order.valid?
        expect(valid_order).must_equal false
        expect(order.errors.messages).must_include :name
        expect(order.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "requires an email if status is not nil" do
        order.email = nil
        # order.status == "complete"
        valid_order = order.valid?
        expect(valid_order).must_equal false
        expect(order.errors.messages).must_include :email
        expect(order.errors.messages[:email]).must_equal ["can't be blank"]
      end

      it "requires an address if status is not nil" do
        order.address = nil
        # order.status == "complete"
        valid_order = order.valid?
        expect(valid_order).must_equal false
        expect(order.errors.messages).must_include :address
        expect(order.errors.messages[:address]).must_equal ["can't be blank"]
      end

      it "requires cc if status is not pending" do
        order.cc = nil
        # order.status == "complete"
        valid_order = order.valid?
        expect(valid_order).must_equal false
        expect(order.errors.messages).must_include :cc
        expect(order.errors.messages[:cc]).must_equal ["can't be blank"]
      end

      it "requires csv if status is not pending" do
        order.csv = nil
        # order.status == "complete"
        valid_order = order.valid?
        expect(valid_order).must_equal false
        expect(order.errors.messages).must_include :csv
        expect(order.errors.messages[:csv]).must_equal ["can't be blank"]
      end

      it "requires expiration_date if status is not pending" do
        order.expiration_date = nil
        # order.status == "complete"
        valid_order = order.valid?
        expect(valid_order).must_equal false
        expect(order.errors.messages).must_include :expiration_date
        expect(order.errors.messages[:expiration_date]).must_equal ["can't be blank"]
      end
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
        expect(orderitem).must_be_instance_of Orderitem
      end
    end
  end
end
