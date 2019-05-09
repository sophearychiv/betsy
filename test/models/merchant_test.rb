require "test_helper"

describe Merchant do
  before do
    @merch =  merchants(:kim)
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
        username: 'testuser',
        email: 'testemail@itsy.com',
        uid: 1010,
        provider: 'github'
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

    describe "paid orders sum" do
      before do
        order1 = orderitems(:item5)
      end

      it "returns correct number of orders for current merchant" do
        @merch2.orderitems.length.must_equal 3
      end

      it "returns the correct sum for paid orders for current merchant" do
        expect(@merch2.paid_orders_sum).must_equal 1197
      end
    end

    describe "complete orders sum" do
      it "returns the correct sum for complete orders for current merchant" do
      end
    end
  end
end