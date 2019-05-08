require "test_helper"

describe CategoriesController do
  describe "Loggin in user" do
    before do
      @user = perform_login
    end

    describe "index" do
      it "should get the index page" do
        get categories_path

        must_respond_with :success
      end
    end

    describe "show" do
      let(:category) { categories(:food) }
      it "can get the category show page for a valid category" do
        get categories_path(category.id)

        must_respond_with :success
      end

      it "will redirect and give flash messages for an invalid category" do
        invalid_cat_id = -1

        get categories_path(invalid_cat_id)

        # must_respond_with :redirect
        # must_redirect_to root_path
        expect(flash[:status]).must_equal :warning
        expect(flash[:result_text]).must_equal "A problem occurred: Media not found"
      end
    end

    describe "new" do
      it "should get new page" do
        get categories_new_path

        must_respond_with :success
      end
    end

    describe "create" do
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
        expect(flash[:status]).must_equal :success
        expect(flash[:result_text]).must_equal "Successfully created #{category_hash[:category][:name]} category"
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
        expect(flash[:status]).must_equal :warning
        expect(flash[:result_text]).must_equal "An itsy problem occurred: Could not add category"
        expect(session[:user_id]).must_equal @user.id
      end
    end
  end

  describe "Logged out user" do
    describe "index" do
      it "should get the index page" do
        get categories_path

        must_respond_with :success
      end
    end

    describe "new" do
      it "will redirect when a logged out user tried to access the new category page" do
        get categories_new_path

        must_redirect_to root_path
        expect(flash[:status]).must_equal :warning
        expect(flash[:result_text]).must_equal "An itsy problem occurred: You must login to view this page"
      end
    end

    describe "create" do
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
        expect(flash[:status]).must_equal :warning
        expect(flash[:result_text]).must_equal "An itsy problem occurred: You must login to view this page"
        expect(session[:user_id]).must_equal nil
      end
    end
  end
end
