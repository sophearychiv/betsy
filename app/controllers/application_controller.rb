class ApplicationController < ActionController::Base
  before_action :find_merchant

  def find_merchant
    @current_merchant = Merchant.find_by(id: session[:user_id])
  end

  def require_login
    current_merchant = find_merchant
    if current_merchant.nil?
      flash[:error] = "You must be logged in to do this action."
      redirect_to root_path
    end
  end
end
