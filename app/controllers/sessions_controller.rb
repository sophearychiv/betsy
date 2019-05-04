class SessionsController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")

    if merchant
      flash[:success] = "Welcome #{merchant.username}"
    else
      merchant = Merchant.build_from_github(auth_hash)
    
      if merchant.save
        flash[:success] = "Logged in as #{merchant.username}"
      else
        flash[:error] = "Could not log in with account #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = merchant.id
    return redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
  end
end
