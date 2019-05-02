require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new }
  let(:kim) { merchants(:kim) }
 
 
  describe "relations" do
    it "must be valid" do
      value(merchant).must_be :valid?
    end
  
    it "has products" do
      expect( kim.products ).must_respond_to :each

      kim.products.each do |product|
        expect( product ).must_be_instance_of Product
      end
    end  
    
  end
end
