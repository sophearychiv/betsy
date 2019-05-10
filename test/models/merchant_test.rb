require "test_helper"

describe Merchant do
  before do
    @merch = merchants(:kim)
    @merch2 = merchants(:stephanie)
  end

  describe "relations" do
    it "must be valid" do
      value(@merch).must_be :valid?
    end
    it "has products" do
      expect(@merch.products).must_respond_to :each
      @merch.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end
  end

  describe "validations" do
    let(:new_merch) {
      Merchant.new(
        username: "testuser",
        email: "testemail@itsy.com",
        uid: 1010,
        provider: "github",
      )
    }
    it "is a valid with unique email and username" do
      expect(@merch).must_be :valid?
    end

    it "invalid without username" do
      @merch.username = nil
      expect(@merch).wont_be :valid?
    end

    it "invalid with already used username" do
      expect(new_merch).must_be :valid?
      new_merch.username = @merch.username
      expect(new_merch).wont_be :valid?
    end

    it "invalid without an email" do
      new_merch.email = nil
      expect(new_merch).wont_be :valid?
    end

    it "invalid with already used email" do
      expect(new_merch).must_be :valid?
      new_merch.email = @merch.email
      expect(new_merch).wont_be :valid?
    end
  end

  describe "custom methods" do
    describe "total revenue" do
      before do
        @merch = merchants(:sopheary)
      end

      it "returns total revenue for that user" do
        expect(@merch.total_revenue).must_equal 1598
      end
    end
  end

  describe "paid orders sum" do
    before do
      order1 = orderitems(:item5)
    end

    it "returns correct number of orders for current merchant" do
      @merch2.orderitems.length.must_equal 3
    end
  end

  describe "items_by_status" do
    it "if arg is 'all', returns a collection of orderitems as a hash" do
      orderitems = @merch.items_by_status("all")

      orderitems.each do |key, value|
        expect(STATUSES).must_include key
        value.each do |item|
          expect(item).must_be_kind_of Orderitem
        end
      end

      expect(orderitems).must_be_kind_of Hash
    end
  end

  it "if arg is valid status, returns a collection of orderitems as an array" do
    orderitems = @merch.items_by_status("complete")

    expect(orderitems).must_be_kind_of Array
    orderitems.each do |item|
      expect(item).must_be_kind_of Orderitem
    end
  end
end

describe "self.items_by_orderid(items)" do
  it "takes in an array of orderitems and returns items as a hash grouped by orderid" do
    item1 = orderitems(:item1)
    item2 = orderitems(:item2)
    item3 = orderitems(:item3)
    items = []
    items << item1
    items << item2
    items << item3
    order_ids = []

    orderitems = Merchant.items_by_orderid(items)
    orderitems.each do |key, value|
      order_ids << key
      value.each do |item|
        expect(item).must_be_kind_of Orderitem
      end
    end

    expect(order_ids.uniq.length).must_equal 3
  end
end
