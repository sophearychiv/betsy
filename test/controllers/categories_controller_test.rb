require "test_helper"

describe CategoriesController do
  describe "Loggin in user" do
    before do
      @user = perform_login
    end

    it "should get new page" do
      get categories_new_path

      must_respond_with :success
    end

    it "can create a new category given valid attributes for a logged in user" do
      category_hash = {
        "category": {
          name: "Tiny pizzas",
        },
      }

      expect {
        post categories_path(params: category_hash)
      }.must_change "Category.count", 1

      must_respond_with :redirect
      must_redirect_to merchant_path(@user.id)
      expect(flash[:success]).must_equal "Successfully created #{category_hash[:category][:name]} category"
      expect(session[:user_id]).must_equal @user.id
    end

    it "won't create a category for a logged in user given invalid attributes" do
      @user = perform_login

      category_hash = {
        "category": {
          name: "",
        },
      }

      expect {
        post categories_path(params: category_hash)
      }.wont_change "Category.count"

      must_respond_with :bad_request
      expect(flash[:error]).must_equal "An itsy problem occurred: Could not add category"
      expect(session[:user_id]).must_equal @user.id
    end
  end

  describe "Logged out user" do
    it "will redirect when a logged out user tried to access the new category page" do
      get categories_new_path

      must_redirect_to root_path
      flash[:error].must_equal "An itsy problem occurred: You must login to view this page"
    end

    it "will redirect a logged out user and not allow them to create a category" do
      category_hash = {
        "category": {
          name: "Tiny pizzas",
        },
      }

      expect {
        post categories_path(params: category_hash)
      }.wont_change "Category.count"

      must_respond_with :redirect
      must_redirect_to root_path
      expect(flash[:error]).must_equal "An itsy problem occurred: You must login to view this page"
      expect(session[:user_id]).must_equal nil
    end
  end
end
