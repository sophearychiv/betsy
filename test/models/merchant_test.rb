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
      expect( @merch.products ).must_respond_to :each

      @merch.products.each do |product|
        expect( product ).must_be_instance_of Product
      end
    end  
    
  end

  # describe "validations" do
  #   let(:new_merchant) {
  #     Merchant.new
  #   }
  #   it "" do

    
  #   end
  # end
end
