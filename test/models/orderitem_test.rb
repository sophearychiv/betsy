require "test_helper"

describe Orderitem do
  before do
    @orderitem = orderitems(:item1)
  end

  it "must be valid" do
    value(@orderitem).must_be :valid?
  end

  describe "relationships" do
    it "has an order" do
      @orderitem.must_respond_to :order
      @orderitem.order.must_be_kind_of Order  
    end

    it "has a product" do
      @orderitem.must_respond_to :product
      @orderitem.product.must_be_kind_of Product
    end

  end 

  describe "validations" do  
    it "valid with quantity" do
      
      expect(@orderitem).must_be :valid?

    end

    it "invalid without quantity" do
      @orderitem.quantity = nil

      expect(@orderitem).wont_be :valid?
    end

    it "invalid when the quantity is less than zero" do
      @orderitem.quantity = -1

      expect(@orderitem).wont_be :valid?

      @orderitem.quantity = 0

      expect(@orderitem).wont_be :valid?
    end
  end

end
