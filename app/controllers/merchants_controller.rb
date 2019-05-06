class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show, :dashboard]

  def index
    @merchants = Merchant.all
  end

  # def new
  #   @merchant = Merchant.new
  # end

  def show
  end

  def dashboard
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

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
    head :not_found unless @merchant
  end

  # def merchant_params
  #   return params.require(:merchant).permit(
  #            :username,
  #            :email,
  #            :provider,
  #            :uid,
  #          )
  # end
end
