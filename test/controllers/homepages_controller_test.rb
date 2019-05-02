require "test_helper"

describe HomepagesController do
  it "should get root" do
    get root_path

    must_respond_with :success
  end
end
