require "test_helper"

describe MerchantsController do
  let(:merchant_info) {
    {
      merchant:
      {
        username: 'test',
        email: 'itsytest@itsy.com',
        uid: 2391,
        provider: 'github'
      }
    }
  }

  let (:merchant) {
    merchants(:stephanie)
  }


  describe "index action" do
    it "should get to the index" do

      get merchants_path

      must_respond_with :success
    end
  end

  describe "show action" do
    it "responds with success for existing merchant" do
      get merchant_path(merchant.id)
      must_respond_with :success
    end

    it "responds with not found for invalid merchant" do
      get merchant_path(-1)

      must_respond_with 404
    end
  end
end
