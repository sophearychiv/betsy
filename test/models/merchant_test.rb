require "test_helper"
require "pry"

describe Merchant do
  let(:merchant) { Merchant.new }
  let(:merch_1) { merchants(:merch_1) }
 
 
  describe "relations" do
    it "must be valid" do
      binding.pry
      value(merchant).must_be :valid?
    end
  
    it "has products" do
      expect( merch_1.products ).must_respond_to :each

      merch_1.products.each do |product|
        expect( product ).must_be_instance_of Product
      end
    end  
    
  end
end
