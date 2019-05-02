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

    is_successful = @merchant.save
    if is_successful
      flash.now[:failure] = "Unable to create #{@merchant.category}"
      @merchant.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render(:new, status: :bad_request)
    end
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    render :not_found unless @merchant
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])

    if @merchant.save(merchant_params)
      redirect_to merchant_path(@merchant)
    else
      render :edit
    end
  end

  def destroy
    @merchant.destroy
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
