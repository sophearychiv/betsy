require "test_helper"

describe HomepagesController do
  it "should get root" do
    get homepages_root_url
    value(response).must_be :successful?
  end
end
