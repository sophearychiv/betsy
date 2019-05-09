class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show, :dashboard]

  def index
    @merchants = Merchant.all
  end

  def show
  end

  def dashboard
    @merchant = Merchant.find_by(id: session[:user_id])
    @orderitems = @merchant.items_by_status("all")
    @pendingitems = Merchant.items_by_orderid(@orderitems["pending"])
    @paiditems = Merchant.items_by_orderid(@orderitems["paid"])
    @completeitems = Merchant.items_by_orderid(@orderitems["complete"])
    @cancelleditems = Merchant.items_by_orderid(@orderitems["cancelled"])
    @products = @merchant.products
    @activeproducts = @products.order(:name).where(active: true).where("stock > ?", 0)
    @soldout = @products.order(:name).where(active: true).where(stock: 0)
    @inactive = @products.order(:name).where(active: false)
  end

  private

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
    head :not_found unless @merchant
  end
end
