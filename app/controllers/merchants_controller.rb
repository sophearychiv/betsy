require "test_helper"

class MerchantsController < ApplicationController

  def index
    @merchants = Merchants.all
  end

  def new
    @merchant = Merchant.new
  end
  
  def create
    @merchant = Merchant.new(merchant_params)
  end




  private 
  
   def merchant_params
     return params.require(:merchant).permit(
       :username,
       :email,
       :provider,
       :uid,
     )
   end

end
