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


  end

end
