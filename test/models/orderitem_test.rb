require "test_helper"

describe Orderitem do

  describe "valid" do
    it "must be valid" do
      value(orderitem).must_be :valid?
    end
  end
end
