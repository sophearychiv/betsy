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

  describe "index" do
    it "should get to the index" do

      get merchants_path

      must_respond_with :success
    end
  end
end
