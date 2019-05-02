class SessionsController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    
    merchant = Merchant.find_by uid: auth_hash[:uid], provider: "github"
    
    if merchant
      flash[:success] = "Welcome #{merchant.username}"
    else
      merchant = Merchant.build_from_github(auth_hash)
    end
    
    if merchant.save
      flash[:success] = "Logged in as #{merchant.username}"
    else
      flash[:error] = "Could not log in with account #{merchant.errors.messages}"
      return redirect_to root_path
    end
    
    session[:user_id] = user.id
    
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:status] = :success
    flash[:message] = "Successfully logged out"
    redirect_to root_path
  end
end