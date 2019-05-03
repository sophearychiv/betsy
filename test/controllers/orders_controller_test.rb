require "test_helper"

describe OrdersController do
  describe "index" do
    before do
      perform_login(merchants(:sopheary))
    end
    it "should get index of all orders" do
      get orders_path
      must_respond_with :success
    end
  end

  describe "show" do
    before do
      perform_login(merchants(:sopheary))
    end
    it "should be OK to show an order" do
      order = orders(:one)

      get order_path(order.id)

      must_respond_with :success
    end

    it "should give a flash notice when trying to access an invalid order" do
      order_id = Order.last.id + 1

      get order_path(order_id)

      must_respond_with :redirect
      expect(flash[:error]).must_equal "Unknown order"
    end
  end

  describe "create" do
    describe "logged-in merchants" do
      before do
        perform_login(merchants(:sopheary))
      end
      it "will save a new order and redirect if given valid inputs" do
        input_order = {
          order: {
            address: "12345 St SE bothell, wa",
            name: "Sophie",
            status: "complete",
            cc: 123,
            expiration_date: Date.today,
            csv: 123,
            email: "sophie@ada.com",
          },
        }

        expect {
          post orders_path, params: input_order
        }.must_change "Order.count", 1

        new_order = Order.find_by(id: Order.last.id)
        expect(new_order).wont_be_nil
        expect(new_order.address).must_equal input_order[:order][:address]
        expect(new_order.name).must_equal input_order[:order][:name]
        expect(new_order.status).must_equal input_order[:order][:status]
        expect(new_order.cc).must_equal input_order[:order][:cc]
        expect(new_order.expiration_date).must_equal input_order[:order][:expiration_date]
        expect(new_order.csv).must_equal input_order[:order][:csv]
        expect(new_order.email).must_equal input_order[:order][:email]
      end

      it "will give a 400 error with invalid params" do
        input_order = {
          order: {
            address: "12345 St SE bothell, wa",
            name: "Sophie",
            status: "complete",
            cc: 123,
            expiration_date: Date.today,
            csv: 123,
            email: nil,
          },
        }

        expect {
          post orders_path, params: input_order
        }.wont_change "Order.count"

        expect(flash[:email]).must_equal ["can't be blank"]
        must_respond_with :bad_request
      end
    end

    describe "Not Logged in users (Guest Users)" do
      it "will redirect to some page if the non-logged-in user attempts to create an order" do
      end
    end
  end
end
