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
      expect(order.status).must_equal Order::PENDING
    end

    it "should respond with a bad request if the input is invalid" do
      input_order = {
        order: {
          address: nil,
          name: nil,
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

    it "should flash a message to the user if item quantity has changed in their cart" do
      orderitem = create_cart
      orderitem.quantity = 2
      orderitem.save
      orderitem.reload
      orderitem.product.stock = 1
      orderitem.product.save
      orderitem.product.reload

      get order_path(session[:order_id])

      expect(flash.now[:status]).must_equal :warning
      expect(flash.now[:result_text]).must_equal "Some item quantities in your cart have changed due to availability: #{orderitem.product.name}"
    end

    it "should flash a message to the user if multiple item quantities have changed in their cart" do
      orderitem = create_cart
      orderitem.quantity = 2
      orderitem.save
      orderitem.reload
      orderitem.product.stock = 1
      orderitem.product.save
      orderitem.product.reload

      orderitem2 = orderitems(:item2)
      order = orderitem.order
      order.orderitems << orderitem2
      orderitem2.product.stock = 0
      orderitem2.product.save
      orderitem2.reload
      orderitem2.product.reload

      get order_path(session[:order_id])

      expect(flash.now[:status]).must_equal :warning
      expect(flash.now[:result_text]).must_equal "Some item quantities in your cart have changed due to availability: #{orderitem.product.name}, #{orderitem2.product.name}"
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
      expect(order.status).must_equal Order::PAID
    end

    it "redirects to root path if the order is not found" do
      order_id = Order.last.id + 1
      expect {
        patch order_path(order_id), params: input_order
      }.wont_change "Order.count"

      get confirmation_path
      must_respond_with :redirect
    end
  end

  describe "cancel" do
    it "can cancel the order" do
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
      patch order_path(order.id), params: input_order

      expect {
        patch cancel_order_path(order.id), params: input_order
      }.wont_change "Order.count"

      order.reload

      must_respond_with :redirect
      must_redirect_to root_path
      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_equal "Your order has been cancelled."
      expect(session[:order_id]).must_be_nil
      expect(order.status).must_equal Order::CANCELLED
    end

    it "gives flash notice when the order is not found" do
      order_id = Order.last.id + 1
      expect {
        patch cancel_order_path(order_id), params: input_order
      }.wont_change "Order.count"

      must_respond_with :redirect
      expect(flash[:status]).must_equal :error
      expect(flash[:result_text]).must_equal "Order does not exist."
    end
  end

  describe "shipped" do
    it "can change an order status to shipped" do
      user = perform_login

      expect {
        patch shipped_path(order.id)
      }.wont_change "Order.count"

      order.reload

      expect(order.status).must_equal Order::COMPLETE
      must_respond_with :redirect
      must_redirect_to dashboard_path(session[:user_id])
      expect(flash[:status]).must_equal :success
      expect(flash[:result_text]).must_equal "Little order ##{order.id} marked shipped!"
    end

    it "will redirect given an invalid order" do
      user = perform_login
      invalid_id = -1

      expect {
        patch shipped_path(-1)
      }.wont_change "Order.count"

      must_respond_with :redirect
      must_redirect_to dashboard_path(session[:user_id])
      expect(flash[:status]).must_equal :warning
      expect(flash[:result_text]).must_equal "An itsy problem occurred: Could not find order"
    end
  end
end
