require "test_helper"

describe Merchant do
  before do 
    @merch =  merchants(:kim)
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

    describe "total  revenue" do
      before do 
        @merch = merchants(:sopheary)
      end

      it "returns total revenue for that user" do
        expect(@merch.total_revenue).must_equal 1598
      end
    end
  end
end