require "test_helper"

describe OrderitemsController do
  let(:product) { products(:product1) }
  let(:product_two) { products(:product2) }
  let(:orderitem_hash) { { quantity: 1 } }

  describe "logged in user" do
    before do
      @user = perform_login
    end

    describe "create" do
      it "can create a new order item given a valid product" do
        expect {
          post product_orderitems_path(product.id), params: orderitem_hash
        }.must_change "Orderitem.count", 1

        must_respond_with :redirect
        must_redirect_to orders_path
        expect(flash[:status]).must_equal :success
        expect(flash[:result_text]).must_equal "Succesfully added an itsy item to your cart"
      end

      it "will redirect to root path given an non-existant product" do
        invalid_product_id = -1

        expect {
          post product_orderitems_path(invalid_product_id), params: orderitem_hash
        }.wont_change "Orderitem.count"

        must_respond_with :redirect
        must_redirect_to products_path
        expect(flash[:status]).must_equal :warning
        expect(flash[:result_text]).must_equal "An itsy problem occurred: can't find product"
      end

      it "will flash an error and redirect if not enough stock is available" do
        stock = product.stock
        orderitem_hash = {
          quantity: 2,
        }

        expect {
          post product_orderitems_path(product.id), params: orderitem_hash
        }.wont_change "Orderitem.count"

        flash[:status] = :warning
        flash[:result_text] = "An itsy problem occurred: not enough stock available"
        must_redirect_to product_path(product.id)
        expect(product.stock).must_equal stock
      end

      it "must create a new order if one doesn't already exist" do
        expect {
          post product_orderitems_path(product.id), params: orderitem_hash
        }.must_change "Order.count", 1

        order = Order.find_by(id: session[:order_id])
        expect(order.valid?).must_equal true
        expect(order.orderitems.length).must_equal 1
      end

      it "will add orderitems to an order already in existance without creating a new order" do
        post product_orderitems_path(product_two.id), params: orderitem_hash

        order = Order.find_by(id: session[:order_id])

        expect {
          post product_orderitems_path(product_two.id), params: orderitem_hash
        }.wont_change "Order.count"

        expect(order.orderitems.length).must_equal 2
        expect(session[:order_id]).must_equal order.id
      end
    end

    describe "edit" do
      it "can edit an existing order item" do
      end
    end

    describe "update" do
      it "should get update" do
      end
    end

    describe "destroy" do
      it "should get destroy" do
      end
    end
  end

  describe "logged out user" do
  end
end
