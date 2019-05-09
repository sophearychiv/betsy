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
<<<<<<< HEAD

  describe "status_nil?" do
    it "returns true if status is nil" do
      order = orders(:one)
      order.status = nil
      expect(order.status_nil?).must_equal true
    end
  end

  describe "sub_total" do
    it "gets the sub total" do
      product = products(:product1)
      order = Order.create(status: nil)
      orderitem = Orderitem.create(order_id: order.id, product_id: product.id, quantity: 1)
      expected_sub_total = product.price
      expect(order.sub_total).must_equal expected_sub_total
    end
  end

  describe "tax" do
    it "calculates the tax correctly" do
      product = products(:product1)
      order = Order.create(status: nil)
      orderitem = Orderitem.create(order_id: order.id, product_id: product.id, quantity: 1)
      expected_tax = product.price * 0.09

      expect(order.tax).must_equal expected_tax
    end
  end

  describe "total" do
    it "calculates the total price correctly" do
      product = products(:product1)
      order = Order.create(status: nil)
      orderitem = Orderitem.create(order_id: order.id, product_id: product.id, quantity: 1)
      expected_total = (product.price * 0.09) + product.price

      expect(order.total).must_equal expected_total
    end
  end
=======
>>>>>>> parent of 93fce73... tests for order_model
end
