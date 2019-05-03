class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  # def new
  #   @merchant = Merchant.new
  # end

  def show
    @merchant = Merchant.find_by(id: params[:id])

    unless @merchant
      head :not_found
    end
  end

  def dashboard
    @merchant = Merchant.find_by(id: params[:id])
  end

  # def edit
  #   @merchant = Merchant.find(params[:id])
  # end

  # def update
  #   @merchant = Merchant.find(params[:id])

  #   if @merchant.save(merchant_params)
  #     redirect_to merchant_path(@merchant)
  #   else
  #     render :edit
  #   end
  # end
  
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
