class MerchantsController < ApplicationController
  def index
    @merchants = Merchants.all
  end

  def new
    @merchant = Merchant.new
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])

    if @merchant.save(merchant_params)
      flash[:success] = "Successfully updated #{@merchant.username}."
      redirect_to merchant_path(@merchant.id)
    else
      render :edit
      flash.now[:error] = "Sorry. There was a problem finding that merchant."
      render :edit, status: :not_found
    end
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
    redirect_to merchants_path
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
