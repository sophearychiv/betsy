ENV["RAILS_ENV"] = "test"
require "simplecov"
require "simplecov-console"
# SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start "rails"
SimpleCov.start do
  add_filter "app/mailers/application_mailer.rb"
  add_filter "app/jobs/application_job.rb"
  add_filter "app/channels/application_cable/connection.rb"
  add_filter "app/channels/application_cable/channel.rb"
end
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"  # for Colorized output
#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_merchant_hash(user)
    return {
             provider: user.provider,
             uid: user.uid,
             info: {
               name: user.username,
               email: user.email,
             },
           }
  end

  def perform_login(user = nil)
    user ||= merchants(:sopheary)

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_merchant_hash(user))

    get auth_callback_path(:github)

    # must_respond_with :redirect
    # must_redirect_to root_path

    return user
  end

  def create_cart(product = nil)
    product ||= products(:product4)

    orderitem_hash = {
      orderitem: {
        quantity: 1,
      },
    }

    expect {
      post product_orderitems_path(product.id), params: orderitem_hash
    }.must_change "Orderitem.count", 1

    orderitem = Orderitem.find_by(product: product)

    return orderitem
  end
end
