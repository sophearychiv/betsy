require "test_helper"

describe OrdersController do
  let(:order) {
    order = orders(:one)
  }

  let(:orderitem_hash) { { quantity: 1 } }

  let(:product) { products(:product1) }

  describe "index" do
    it "should get index of all orders" do
      get orders_path
      must_respond_with :success
    end
  end

  describe "edit" do
    it "should get the edit" do
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
      post product_orderitems_path(product.id), params: orderitem_hash
      order = Order.last
      expect {
        patch order_path(order.id), params: input_order
      }.wont_change "Order.count"
      must_respond_with :redirect
      # binding.pry
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
      post product_orderitems_path(product.id), params: orderitem_hash
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
      post product_orderitems_path(product.id), params: orderitem_hash
      expect {
        patch order_path(order.id), params: input_order
      }.wont_change "Order.count"

      must_respond_with :bad_request
    end
  end

  describe "create" do
    it "can create an order when an orderitem is added to the cart" do
      expect {
        post product_orderitems_path(product.id), params: orderitem_hash
      }.must_change "Order.count", 1

      must_respond_with :redirect
    end

    it "should respond with a bad request when it cannot be created" do
      input_order = {
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

      expect {
        post orders_path, params: input_order
      }.wont_change "Order.count"

      must_respond_with :bad_request
    end
  end

  describe "show" do
    let(:orderitem_hash) { { quantity: 1 } }

    it "should be OK to show an order" do
      # Do some controller action to add an item to a cart
      product = products(:product1)
      expect {
        post product_orderitems_path(product.id), params: orderitem_hash
      }.must_change "Orderitem.count", 1
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
    it "can get confirmation after purchasing" do
      product = products(:product1)
      expect {
        post product_orderitems_path(product.id), params: orderitem_hash
      }.must_change "Orderitem.count", 1

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
      order = Order.last
      expect {
        patch order_path(order.id), params: input_order
      }

      get confirmation_path

      must_respond_with :success
    end

    it "changes the order's status to 'paid' " do
      product = products(:product1)

      expect {
        post product_orderitems_path(product.id), params: orderitem_hash
      }.must_change "Orderitem.count", 1
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
      order = Order.last
      expect {
        patch order_path(order.id), params: input_order
      }.wont_change "Order.count"

      get confirmation_path

      order.reload
      expect(order.status).must_equal "paid"
    end
  end

  describe "create" do
    # it "will save a new order and redirect if given valid inputs" do
    #   input_order = {
    #     order: {
    #       address: "12345 St SE bothell, wa",
    #       name: "Sophie",
    #       status: "complete",
    #       cc: 123,
    #       expiration_date: Date.today,
    #       csv: 123,
    #       email: "sophie@ada.com",
    #     },
    #   }

    #   expect {
    #     post orders_path, params: input_order
    #   }.must_change "Order.count", 1

    #   new_order = Order.find_by(id: Order.last.id)
    #   expect(new_order).wont_be_nil
    #   expect(new_order.address).must_equal input_order[:order][:address]
    #   expect(new_order.name).must_equal input_order[:order][:name]
    #   expect(new_order.status).must_equal input_order[:order][:status]
    #   expect(new_order.cc).must_equal input_order[:order][:cc]
    #   expect(new_order.expiration_date).must_equal input_order[:order][:expiration_date]
    #   expect(new_order.csv).must_equal input_order[:order][:csv]
    #   expect(new_order.email).must_equal input_order[:order][:email]
    # end

    # it "will give a 400 error with invalid params" do
    #   input_order = {
    #     order: {
    #       address: "12345 St SE bothell, wa",
    #       name: "Sophie",
    #       status: "complete",
    #       cc: 123,
    #       expiration_date: Date.today,
    #       csv: 123,
    #       email: nil,
    #     },
    #   }

    #   expect {
    #     post orders_path, params: input_order
    #   }.wont_change "Order.count"

    #   expect(flash[:email]).must_equal ["can't be blank"]
    #   must_respond_with :bad_request
    # end
  end
end
