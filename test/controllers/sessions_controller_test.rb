require "test_helper"

describe SessionsController do
  describe "create" do

    it "can log in an existing user" do
      merchant = merchants(:stephanie)
      
      perform_login(merchant)

      expect(session[:user_id]).must_equal merchant.id
      expect(flash[:success]).must_equal "Welcome #{merchant.username}"
    end


    it "can log in a new user" do
      merch_count = Merchant.count
      new_user = Merchant.new(
        username: "newtest user", 
        email: "itsysgiraffe@itsy.com", 
        uid: 1111, 
        provider: "github"
      )

      expect(new_user.valid?).must_equal true

      perform_login(new_user)
      must_redirect_to root_path

      expect(Merchant.count).must_equal merch_count + 1
      
    end

    it "invalid users don't create new user" do
      merch_count = Merchant.count

      invalid_user = Merchant.new(
        username: nil, 
        email: nil
      )

      expect(invalid_user).wont_be :valid?

      perform_login(invalid_user)
      must_redirect_to root_path

      expect(session[:user_id]).must_equal nil
      expect(Merchant.count).must_equal merch_count 

    end
  end

  describe "destroy" do
    it "logs a user out" do
      merchant = merchants(:stephanie)

      perform_login(merchant)
 
      delete logout_path(merchant)
      must_redirect_to root_path
    end
  end
end
