require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new }
  let(:merch_1) { merchants(:merch_1) }

  it "must be valid" do
    value(merchant).must_be :valid?
  end

  describe "relations" do
    it "has products" do
      expect( merch_1.products ).must_respond_to :each

      merch_1.products.each do |product|
        expect( product ).must_be_instance_of Product
      end
    end  
    
  end
end
