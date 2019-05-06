require "test_helper"

describe OrderitemsController do
  let(:product) { products(:product1) }
  let(:product_two) { products(:product2) }
  let(:product_four) { products(:product4) }
  let(:item1) { orderitems(:item1) }
  let(:item4) { orderitems(:item4) }
  let(:orderitem_hash) { { quantity: 1 } }
  let(:orderitem_hash2) { { quantity: 2 } }

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
        must_redirect_to product_path(product.id)
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
        expect(flash[:result_text]).must_equal "An itsy problem occurred: Can't find product"
      end

      it "will flash an error and redirect if not enough stock is available" do
        stock = product.stock

        expect {
          post product_orderitems_path(product.id), params: orderitem_hash2
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

      it "will redirect and flash an error if given an invalid quantity" do
        new_orderitem_hash = {
          quantity: -1,
        }

        expect {
          post product_orderitems_path(product_two.id), params: new_orderitem_hash
        }.wont_change "Orderitem.count"

        must_respond_with :redirect
        must_redirect_to product_path(product_two.id)
        expect(flash[:status]).must_equal :warning
        expect(flash[:result_text]).must_equal "An itsy problem occurred: Could not add item to cart"
      end
    end

    describe "update" do
      it "should update an item given a valid orderitem" do
        expect {
          patch orderitem_path(item4.id), params: orderitem_hash2
        }.wont_change "Orderitem.count"

        item4.reload

        must_respond_with :redirect
        must_redirect_to order_path(item4.order.id)
        expect(item4.quantity).must_equal 2
        expect(flash[:status]).must_equal :success
        expect(flash[:result_text]).must_equal "Successfully updated item: #{item4.product.name}"
      end

      it "will redirect and flash an error message given an invalid orderitem" do
        invalid_orderitem_id = -1

        expect {
          patch orderitem_path(invalid_orderitem_id), params: orderitem_hash2
        }.wont_change "Orderitem.count"

        must_respond_with :redirect
        must_redirect_to root_path
        expect(flash[:status]).must_equal :warning
        expect(flash[:result_text]).must_equal "An itsy problem occurred: Could not find item"
      end

      it "will flash an error message if given an invalid quantity" do
        new_orderitem_hash = {
          quantity: -1,
        }

        expect {
          patch orderitem_path(item1.id), params: new_orderitem_hash
        }.wont_change "Orderitem.count"

        must_respond_with :redirect
        must_redirect_to order_path(item1.order.id)
        expect(flash[:status]).must_equal :warning
        expect(flash[:result_text]).must_equal "An itsy problem occurred: Could not update item"
      end

      it "will flash an error message if not enough stock available" do
        new_orderitem_hash = {
          quantity: 15,
        }

        expect {
          patch orderitem_path(item1.id), params: new_orderitem_hash
        }.wont_change "Orderitem.count"

        must_respond_with :redirect
        must_redirect_to order_path(item1.order.id)
        expect(flash[:status]).must_equal :warning
        expect(flash[:result_text]).must_equal "An itsy problem occurred: not enough available stock"
      end
    end

    describe "destroy" do
      it "will destroy an existing orderitem" do
        orderitem = create_cart

        expect {
          delete orderitem_path(orderitem.id)
        }.must_change "Orderitem.count", -1
      end
    end
  end

  describe "logged out user" do
  end
end
