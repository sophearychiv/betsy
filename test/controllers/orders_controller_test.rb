require "test_helper"

describe OrdersController do
  let(:order) {
    order = orders(:one)
  }

  let(:orderitem_hash) { { quantity: 1 } }

  let(:product) { products(:product1) }

  let(:input_order) {
    {
      order: {
        address: "12345 St SE bothell, wa",
        name: "Sophie",
        cc: 123,
        expiration_date: Date.today,
        csv: 123,
        email: "sophie@ada.com",
      },
    }
  }

  let(:invalid_input_order) {
    {
      order: {
        address: nil,
        name: nil,
        status: "pending",
        cc: 123,
        expiration_date: Date.today,
        csv: 123,
        email: "sophie@ada.com",
      },
    }
  }

  describe "index" do
    it "should get index of all orders" do
      get orders_path
      must_respond_with :success
    end
  end

  describe "edit" do
    it "should get the edit" do
      create_cart
      order = Order.last
      get edit_order_path(order.id)
      must_respond_with :success
    end
  end

  describe "update" do
    it "can update the order" do
      input_order = {
        order: {
          address: "12345 St SE bothell, wa",
          name: "Sophie",
          cc: 123,
          expiration_date: Date.today,
          csv: 123,
          email: "sophie@ada.com",
        },
      }

      create_cart
      order = Order.last
      expect {
        patch order_path(order.id), params: input_order
      }.wont_change "Order.count"
      must_respond_with :redirect
    end

    it "changes the order's status to 'pending' " do
      input_order = {
        order: {
          address: "12345 St SE bothell, wa",
          name: "Sophie",
          cc: 123,
          expiration_date: Date.today,
          csv: 123,
          email: "sophie@ada.com",
        },
      }

      create_cart

      order = Order.last
      expect {
        patch order_path(order.id), params: input_order
      }.wont_change "Order.count"

      order.reload
      must_respond_with :redirect
      expect(order.status).must_equal "pending"
    end

    it "should respond with a bad request if the input is invalid" do
      input_order = {
        order: {
          address: nil,
          name: nil,
          status: "complete",
          cc: 123,
          expiration_date: Date.today,
          csv: 123,
          email: "sophie@ada.com",
        },
      }

      create_cart

      expect {
        patch order_path(order.id), params: input_order
      }.wont_change "Order.count"

      must_respond_with :bad_request
    end

    it "should redirect to products_path if the order is not found" do
      order_id = Order.last.id + 1

      expect {
        patch order_path(order_id), params: input_order
      }.wont_change "Order.count"

      must_respond_with :redirect
    end
  end

  # describe "create" do
  #   it "can create an order when an orderitem is added to the cart" do
  #     expect {
  #       create_cart
  #     }.must_change "Order.count", 1
  #     # order = Order.last
  #     # expect(order.valid?).must_equal true
  #     must_respond_with :redirect
  #   end

  #   it "should respond with a bad request when the input is invalid" do
  #     create_cart

  #     order = Order.last
  #     expect {
  #       patch order_path(order.id), params: invalid_input_order
  #     }.wont_change "Order.count"

  #     must_respond_with :bad_request
  #   end
  # end

  describe "show" do
    it "should be OK to show an order" do
      create_cart

      order = Order.last

      get order_path(order.id)
      must_respond_with :success
    end

    it "should give a flash notice when trying to access an invalid order" do
      order_id = -1

      get order_path(order_id)

      must_respond_with :redirect
      expect(flash[:status]).must_equal :error
      expect(flash[:result_text]).must_equal "Order not found!"
    end
  end

  describe "confirmation" do
    it "can get confirmation after the purchase" do
      create_cart
      order = Order.last
      expect {
        patch order_path(order.id), params: input_order
      }

      get confirmation_path

      must_respond_with :success
    end

    it "changes the order's status to 'paid' " do
      create_cart
      order = Order.last
      expect {
        patch order_path(order.id), params: input_order
      }.wont_change "Order.count"

      get confirmation_path

      order.reload
      expect(order.status).must_equal "paid"
    end

    it "clears the orderitems in the cart" do
      create_cart
      order = Order.last
      expect {
        patch order_path(order.id), params: input_order
      }.wont_change "Order.count"

      get confirmation_path
      order.reload

      expect(order.orderitems.count).must_equal 0
    end
  end

  describe "destroy" do
    it "can delete the order" do
      create_cart

      order = Order.last

      expect {
        delete order_path(order.id)
      }.must_change "Order.count", -1

      must_respond_with :redirect
      must_redirect_to root_path
      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_equal "Order has been canceled!"
    end

    it "can delete the orderitems in the order" do
      create_cart
      order = Order.last
      orderitem = order.orderitems.first
      orderitem_id = orderitem.id
      expect {
        delete order_path(order.id)
      }.must_change "Order.count", -1

      must_respond_with :redirect
      expect(Orderitem.find_by(id: orderitem_id)).must_be_nil
    end

    it "gives flash notice when the order is not found" do
      order_id = Order.last.id + 1
      expect {
        delete order_path(order_id)
      }.wont_change "Order.count"

      must_respond_with :redirect
      expect(flash[:status]).must_equal :error
      expect(flash[:result_text]).must_equal "Order does not exist."
    end
  end
end
